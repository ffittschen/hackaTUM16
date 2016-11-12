//
//  HomeTabCoordinator.swift
//  HackaTUM
//
//  Created by Florian Fittschen on 11/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import UIKit

class HomeTabCoordinator: NSObject, TabCoordinator {
    
    let tabBarItem: UITabBarItem
    let navigationController: UINavigationController
    var viewModel: HomeTabViewModel
    
    fileprivate let viewController: HomeTabViewController
    
    override init() {
        tabBarItem = UITabBarItem(title: "First", image: nil, selectedImage: nil)
        
        viewModel = HomeTabViewModel(funBucks: 42)
        viewController = HomeTabViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = tabBarItem
        
        super.init()
    }
    
    func start() {
        
    }
}
