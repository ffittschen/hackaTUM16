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
              
        tabBarController.viewControllers = tabs.map() { coordinator -> UIViewController in
            return coordinator.navigationController
        }
        
        tabs.forEach() { $0.start() }
    }
}
