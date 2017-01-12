//
//  AppCoordinator.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 11/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Hue
import RxMoya
import Moya
import Freddy

/**
 Object that bosses one or more view controllers around by taking all of the driving logic
 out of the view controllers, and moving that stuff one layer up.
 
 - note:
 Adapted from: [Coordinators Redux](http://khanlou.com/2015/10/coordinators-redux/)
 */
protocol Coordinator {
    /// Start the work of the `Coordinator`.
    func start()
}

//  Coordinates Main Tab Navigation
class AppCoordinator: NSObject, Coordinator {
    
    fileprivate let disposeBag: DisposeBag
    fileprivate let homeTabCoordinator: HomeTabCoordinator
    fileprivate let scannerTabCoordinator: QRScannerTabViewCoordinator
    fileprivate let backendProvider: RxMoyaProvider<BackendService>

    private var tabBarController: UITabBarController
    private var tabs: [TabCoordinator]
    
    required init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.tabBarController.tabBar.tintColor = UIColor(hex: "df0000")
        
        disposeBag = DisposeBag()
   		homeTabCoordinator = HomeTabCoordinator()
		scannerTabCoordinator = QRScannerTabViewCoordinator()
    	tabs = [scannerTabCoordinator, homeTabCoordinator]
        
        backendProvider = RxMoyaProvider<BackendService>(endpointClosure: endpointClosure)
        
        super.init()
    }
    
    //  This closure adds `application/json` as header and transmits the data in a way known as `raw` in other tools, e.g. Postman
    let endpointClosure = { (target: BackendService) -> Endpoint<BackendService> in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        let endpoint: Endpoint<BackendService> = Endpoint<BackendService>(URL: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: JSONEncoding.default )
        return endpoint.adding(newHttpHeaderFields: ["Content-Type": "application/json"])
    }
    
    func start() {
              
        tabBarController.viewControllers = tabs.map() { coordinator -> UIViewController in
            return coordinator.navigationController
        }
        
        tabs.forEach() { $0.start() }


    }
    
    func registerForPush() {
        guard let pushToken = UserDefaults.standard.string(forKey: "PushDeviceToken") else { fatalError("No push device token found.") }
        
        if let userID = UserDefaults.standard.string(forKey: "UserID") {
            backendProvider.request(.getProfile(id: userID)) { result in
                switch result {
                case .success(let response):
                    guard let json = try? JSON(data: response.data) else {
                        print("Unable to parse JSON Response")
                        return
                    }
                    
                    guard let token = try? json.getString(at: "pushid") else {
                        print("Unable to find 'pushid' in: \(json)")
                        return
                    }
                    
                    if pushToken != token {
                        self.backendProvider.request(.updateProfile(id: try! json.getString(at: "id"),
                                                               name: try! json.getString(at: "name"),
                                                               avatar: try! json.getString(at: "avatar"),
                                                               pushID: token, notificationActive: try! json.getBool(at: "notificationactive")))
                    }
                    
                case.failure(let error):
                    print("Erro while get user: \(error)")
                }
                
            }
        } else {
            backendProvider.request(.postProfile(name: UIDevice.current.identifierForVendor!.uuidString, avatar: "", pushID: pushToken, notificationActive: true)) { result in
                switch result {
                case .success(let response):
                    guard let json = try? JSON(data: response.data) else {
                        print("Unable to parse JSON Response")
                        return
                    }
                    guard let userID = try? json.getString(at: "id") else {
                        print("Unable to find user id in: \(json)")
                        return
                    }
                    
                    UserDefaults.standard.setValue(userID, forKey: "UserID")
                case .failure(let error):
                    print("Erro while post user: \(error)")
                }
            }
            
        }
    }
}
