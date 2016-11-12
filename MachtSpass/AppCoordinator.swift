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

protocol Coordinator {
    func start()
}

class AppCoordinator: NSObject, Coordinator {
    
    fileprivate let disposeBag: DisposeBag
    fileprivate let homeTabCoordinator: HomeTabCoordinator
    fileprivate let scannerTabCoordinator: QRScannerTabViewCoordinator
    private var tabBarController: UITabBarController
    private var tabs: [TabCoordinator]
    
    required init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        
        disposeBag = DisposeBag()
   		homeTabCoordinator = HomeTabCoordinator()
		scannerTabCoordinator = QRScannerTabViewCoordinator()
    	tabs = [homeTabCoordinator, scannerTabCoordinator]
        
        super.init()
    }
    
    func start() {
        tabBarController.viewControllers = tabs.map() { coordinator -> UIViewController in
            return coordinator.navigationController
        }
        
        tabs.forEach() { $0.start() }
    }
    
}
