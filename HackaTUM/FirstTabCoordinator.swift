//
//  FirstTabCoordinator.swift
//  HackaTUM
//
//  Created by Florian Fittschen on 11/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import UIKit

class FirstTabCoordinator: NSObject, TabCoordinator {
    
    let tabBarItem: UITabBarItem
    let navigationController: UINavigationController
    var viewModel: FirstTabViewModel
    
    fileprivate let viewController: FirstTabViewController
    
    override init() {
        tabBarItem = UITabBarItem(title: "First", image: nil, selectedImage: nil)
        
        viewModel = FirstTabViewModel(string: "Example")
        viewController = FirstTabViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = tabBarItem
        
        super.init()
    }
    
    func start() {
        
    }
}
