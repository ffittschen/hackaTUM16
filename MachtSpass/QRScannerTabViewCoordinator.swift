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
import Moya
import Freddy
import Alamofire

class QRScannerTabViewCoordinator: NSObject, TabCoordinator {
    
    fileprivate let disposeBag: DisposeBag
    let tabBarItem: UITabBarItem
    let navigationController: UINavigationController
    var scanResultsViewModel: ScanResultsViewModel
    
    fileprivate let viewController: ScanResultsViewController
    fileprivate let barcodeScannerController: BarcodeScannerController
    fileprivate let backendProvider: RxMoyaProvider<BackendService>
    
    let endpointClosure = { (target: BackendService) -> Endpoint<BackendService> in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        let endpoint: Endpoint<BackendService> = Endpoint<BackendService>(URL: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: JSONEncoding.default )
        return endpoint.adding(newHttpHeaderFields: ["Content-Type": "application/json"])
    }
    
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
        backendProvider = RxMoyaProvider<BackendService>(endpointClosure: endpointClosure)
        
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
        
        let pushID = UserDefaults.standard.string(forKey: "PushDeviceToken") ?? ""
        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
        
        scanResultsViewModel.productID.asObservable()
            .subscribe(onNext: { (productID: String) in
                self.backendProvider.request(.product(id: productID, pushID: pushID, userID: userID), completion: { result in
                    switch result {
                    case .success(let response):
                        let json = try! JSON(data: response.data)
                        
                        let userID = try! json.getString(at: "userid")
                        if UserDefaults.standard.string(forKey: "userID") == nil {
                            UserDefaults.standard.set(userID, forKey: "userID")
                        }
                        
                        self.scanResultsViewModel.productName.value = try! json.getString(at: "product", "title")
                        let imageURL = URL(string: try! json.getString(at: "product", "image"))
                        let task = URLSession.shared.dataTask(with: imageURL!) { data, response, error in
                            guard let data = data, error == nil else { return }
                            
                            DispatchQueue.main.sync() {
                                self.scanResultsViewModel.productImage.value = UIImage(data: data)
                            }
                        }.resume()
                        self.scanResultsViewModel.productDescription.value = try! json.getString(at: "product", "content")
                        self.scanResultsViewModel.productLikes.value = try! json.getInt(at: "rating", "likes")
                        self.scanResultsViewModel.productDislikes.value = try! json.getInt(at: "rating", "dislikes")
                        self.scanResultsViewModel.productFunLevel.value = try! json.getInt(at: "rating", "funfactor")
                    case .failure(let error):
                        Log.error?.message("Error while getting product information: \(error)")
                    }
                })
            })
            .addDisposableTo(disposeBag)
    }
}

extension QRScannerTabViewCoordinator: BarcodeScannerCodeDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        Log.debug?.message("Received Barcode: \(code)")
        
        scanResultsViewModel.qrContent.value = code
        
        barcodeScannerController.resetWithError()
        
        navigationController.popViewController(animated: true)
    }
}

extension QRScannerTabViewCoordinator: BarcodeScannerErrorDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Swift.Error) {
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
    
    func didPressMachtSpassButton() {
        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
        
        scanResultsViewModel.productID
            .subscribe(onNext: { productID in
                self.backendProvider.request(.postQuestion(userID: userID, productID: productID)) { result in
                    switch result {
                    case .success(let response):
                        Log.debug?.message("Posted question. Response: \(response.debugDescription)")
                        if let json = try? JSON(data: response.data) {
                            Log.debug?.message("\(json.description)")
                        }
                    case .failure(let error):
                        Log.error?.message("Error while pressing machtSpassButton: \(error)")
                    }
                    
                }
            })
            .addDisposableTo(disposeBag)
        
    }
}
