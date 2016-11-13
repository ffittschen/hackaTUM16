//
//  HomeTabCoordinator.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 11/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import UIKit
import RxMoya
import Moya

class HomeTabCoordinator: NSObject, TabCoordinator {
    
    let tabBarItem: UITabBarItem
    let navigationController: UINavigationController
    var viewModel: HomeTabViewModel
    
    fileprivate let viewController: HomeTabViewController
    fileprivate let backendProvider: RxMoyaProvider<BackendService>
    
    override init() {
        tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "HomeTabIcon"), selectedImage: nil)
        
        viewModel = HomeTabViewModel(funBucks: 42)
        viewController = HomeTabViewController(viewModel: viewModel)
        
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = tabBarItem
        navigationController.navigationBar.barTintColor = .white
        
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                       width: navigationController.navigationBar.bounds.width - 16,
                                                       height: navigationController.navigationBar.bounds.height - 8))
        titleImageView.image = #imageLiteral(resourceName: "Media Markt")
        titleImageView.contentMode = .scaleAspectFit
        viewController.navigationItem.titleView = titleImageView
        
        backendProvider = RxMoyaProvider<BackendService>()
        
        super.init()
    }
    
    func start() {
        //backendProvider.request()
    }
}
