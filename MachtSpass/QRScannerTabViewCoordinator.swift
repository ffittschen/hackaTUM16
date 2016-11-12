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
        //  Set tabbarItem attributes
        tabBarItem = UITabBarItem(title: "Scan", image: nil, selectedImage: nil)
        tabBarItem.image = #imageLiteral(resourceName: "ScanTabIcon")
        
        //  Init Model & navigation stack
        viewModel = QRScannerTabViewModel()
        viewController = QRScannerTabViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = tabBarItem
        
        //  Set title image
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                       width: navigationController.navigationBar.bounds.width - 16,
                                                       height: navigationController.navigationBar.bounds.height - 8))
        titleImageView.image = #imageLiteral(resourceName: "Media Markt")
        titleImageView.contentMode = .scaleAspectFit
        viewController.navigationItem.titleView = titleImageView
        
        super.init()
    }
    
    private func linkViewModel() {
        //  Load scan results controller when qr code was read
        let _ = viewModel.qrContentValue.subscribe(onNext: { (qrCodeString) in
            guard let productID = qrCodeString else { return }
            let resultsViewController = ScanResultsViewController(viewModel: ScanResultsViewModel(productID: productID))
            self.navigationController.pushViewController(resultsViewController, animated: true)
        })
    }
    
    //  entry point of the view 
    func start() {
        linkViewModel()
    }
}
