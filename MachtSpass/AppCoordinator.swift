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
import Moya

protocol Coordinator {
    func start()
}

//  Coordinates Main Tab Navigation
class AppCoordinator: NSObject, Coordinator {
    
    fileprivate let disposeBag: DisposeBag
    fileprivate let homeTabCoordinator: HomeTabCoordinator
    fileprivate let scannerTabCoordinator: QRScannerTabViewCoordinator
    private var tabBarController: UITabBarController
    private var tabs: [TabCoordinator]
    
    required init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.tabBarController.tabBar.tintColor = UIColor(hex: "df0000")
        
        disposeBag = DisposeBag()
   		homeTabCoordinator = HomeTabCoordinator()
		scannerTabCoordinator = QRScannerTabViewCoordinator()
    	tabs = [scannerTabCoordinator, homeTabCoordinator]
        
        super.init()
    }
    
    func start() {
        let deviceID = UserDefaults.standard.value(forKey: "PushDeviceToken")
        print(deviceID)
//        MoyaProvider<BackendService>().request(.getProfile(deviceID)) { response in
//            
//            print("Got response: \(response)")
//                
//        }
        
        
        tabBarController.viewControllers = tabs.map() { coordinator -> UIViewController in
            return coordinator.navigationController
        }
        
        tabs.forEach() { $0.start() }
    }
    
}
