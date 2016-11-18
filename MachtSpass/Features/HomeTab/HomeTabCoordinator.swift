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
import CleanroomLogger

class HomeTabCoordinator: NSObject, TabCoordinator {
    
    let tabBarItem: UITabBarItem
    let navigationController: UINavigationController
    var viewModel: HomeTabViewModel
    
    fileprivate let viewController: HomeTabViewController
    fileprivate let backendProvider: RxMoyaProvider<BackendService>
    
    override init() {
        
        //  Set tabBarItem attributes
        tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "HomeTabIcon"), selectedImage: nil)
        
        //  Init viewModel & navigation stack
        viewModel = HomeTabViewModel(funBucks: 42)
        viewController = HomeTabViewController(viewModel: viewModel)
        
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = tabBarItem
        navigationController.navigationBar.barTintColor = .white
        
        //  Set title image of navigationBar
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                       width: navigationController.navigationBar.bounds.width - 16,
                                                       height: navigationController.navigationBar.bounds.height - 8))
        titleImageView.image = #imageLiteral(resourceName: "Media Markt")
        titleImageView.contentMode = .scaleAspectFit
        viewController.navigationItem.titleView = titleImageView
        
        //  Init moya Backend Provider
        backendProvider = RxMoyaProvider<BackendService>()
        
        super.init()
        
        //  Set the delegates
        viewController.delegate = self
    }
    
    func start() {
        
    }
}

extension HomeTabCoordinator: HomeTabViewControllerDelegate {
    func didPressGift() {
        Log.debug?.message("TODO: handle gift")
    }
    
    func didPressRedeem() {
        Log.debug?.message("TODO: handle redeem")
    }
}
