//
//  QRScannerTabViewCoordinator.swift
//  MachtSpass
//
//  Created by Peter Christian Glade on 12.11.16.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import UIKit

class QRScannerTabViewCoordinator: NSObject, TabCoordinator {
    
    let tabBarItem: UITabBarItem
    let navigationController: UINavigationController
    var viewModel: QRScannerTabViewModel
    
    fileprivate let viewController: QRScannerTabViewController
    
    override init() {
        tabBarItem = UITabBarItem(title: "Scan", image: nil, selectedImage: nil)
        
        viewModel = QRScannerTabViewModel()
        viewController = QRScannerTabViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = tabBarItem
        
        super.init()
    }
    
    private func linkViewModel() {
        viewModel.qrContentValue.subscribe(onNext: { (qrCodeString) in
            
        })
    }
    
    func start() {
        
    }
}
