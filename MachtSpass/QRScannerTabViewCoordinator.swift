//
//  QRScannerTabViewCoordinator.swift
//  MachtSpass
//
//  Created by Peter Christian Glade on 12.11.16.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import BarcodeScanner
import CleanroomLogger
import RxMoya
import Freddy

class QRScannerTabViewCoordinator: NSObject, TabCoordinator {
    
    fileprivate let disposeBag: DisposeBag
    let tabBarItem: UITabBarItem
    let navigationController: UINavigationController
    var scanResultsViewModel: ScanResultsViewModel
    
    fileprivate let viewController: ScanResultsViewController
    fileprivate let barcodeScannerController: BarcodeScannerController
    fileprivate let backendProvider: RxMoyaProvider<BackendService>
    
    override init() {
        disposeBag = DisposeBag()
        
        //  Set tabBarItem attributes
        tabBarItem = UITabBarItem(title: "Scan", image: #imageLiteral(resourceName: "ScanTabIcon"), selectedImage: nil)
        
        //  Init BarcodeScanner
        BarcodeScanner.Info.text = NSLocalizedString(
            "Halte die Kamera über den QR-Code. Die Produktsuche startet automatisch.", comment: "")
        barcodeScannerController = BarcodeScannerController()
        barcodeScannerController.edgesForExtendedLayout = []
        
        //  Init model & navigation stack
        scanResultsViewModel = ScanResultsViewModel()
        
        viewController = ScanResultsViewController(viewModel: scanResultsViewModel)
        
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = tabBarItem
        navigationController.navigationBar.barTintColor = .white
        
        //  Set title image
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                       width: navigationController.navigationBar.bounds.width - 16,
                                                       height: navigationController.navigationBar.bounds.height - 8))
        titleImageView.image = #imageLiteral(resourceName: "Media Markt")
        titleImageView.contentMode = .scaleAspectFit
        viewController.navigationItem.titleView = titleImageView
        
        //  Init moya Backend Provider 
        backendProvider = RxMoyaProvider<BackendService>()
        
        super.init()
        
        viewController.delegate = self
        barcodeScannerController.codeDelegate = self
        barcodeScannerController.errorDelegate = self
        barcodeScannerController.dismissalDelegate = self
    }
    
    private func showBarcodeScanner() {
        barcodeScannerController.navigationItem.setHidesBackButton(true, animated: false)
        barcodeScannerController.title = "Scan"
        navigationController.pushViewController(barcodeScannerController, animated: true)
    }
    
    //  entry point of the view 
    func start() {
        if UIDevice.isSimulator {
            scanResultsViewModel.qrContent.value = "1234567"
        } else {
            showBarcodeScanner()
        }
    }
}

extension QRScannerTabViewCoordinator: BarcodeScannerCodeDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        Log.debug?.message("Received Barcode: \(code)")
        
        scanResultsViewModel.qrContent.value = code
        
        barcodeScannerController.resetWithError()
        
        
        backendProvider.request(.product(code)).subscribe { event in
            switch event {
            case .next(let response):
                print("Product: \(try! Product(json: try! JSON(data: response.data)))")
            case .error(let error):
                Log.debug?.message("ServerError: Invalid response from Backend: \(error)")
            case .completed:break
            }
            
        }.addDisposableTo(disposeBag)
        
        navigationController.popViewController(animated: true)
    }
}

extension QRScannerTabViewCoordinator: BarcodeScannerErrorDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        Log.error?.message("Error while scanning a barcode:")
        Log.error?.value(error)
    }
}

extension QRScannerTabViewCoordinator: BarcodeScannerDismissalDelegate {
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        navigationController.popViewController(animated: true)
    }
}

extension QRScannerTabViewCoordinator: ScanResultsViewControllerDelegate {
    func didPressScanQRCodeButton() {
        start()
    }
    
    func didTouchMakesFunButton() {
        //  Request server to send notifications to the right users
        
        //  ...
        

    }
}
