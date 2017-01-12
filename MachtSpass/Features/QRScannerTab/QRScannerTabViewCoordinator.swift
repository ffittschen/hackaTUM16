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

class QRScannerTabViewCoordinator: NSObject, TabCoordinator {
    
    let tabBarItem: UITabBarItem
    let navigationController: UINavigationController
    var viewModel: ScanResultsViewModel
    
    fileprivate let disposeBag: DisposeBag
    fileprivate let viewController: ScanResultsViewController
    fileprivate let barcodeScannerController: BarcodeScannerController
    fileprivate let backendProvider: RxMoyaProvider<BackendService>
    
    //  This closure adds `application/json` as header and transmits the data in a way known as `raw` in other tools, e.g. Postman
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
        
        //  Init viewModel & navigation stack
        viewModel = ScanResultsViewModel()
        viewController = ScanResultsViewController(viewModel: viewModel)
        
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
        backendProvider = RxMoyaProvider<BackendService>(endpointClosure: endpointClosure)
        
        super.init()
        
        //  Set the delegates
        viewController.delegate = self
        barcodeScannerController.codeDelegate = self
        barcodeScannerController.errorDelegate = self
        barcodeScannerController.dismissalDelegate = self
    }
    
    func start() {
        //  The barcodeScanner uses the camera, therefore we need to mock the value to avoid simulator crashes
        if UIDevice.isSimulator {
            viewModel.qrContent.value = "1234567"
        } else {
            showBarcodeScanner()
        }
        
        let pushID = UserDefaults.standard.string(forKey: "PushDeviceToken") ?? ""
        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
        
        //  As soon as we successfully scanned a product, we want to get product information from the backend
        viewModel.productID.asObservable()
            .subscribe(onNext: { (productID: String) in
                self.backendProvider.request(.product(id: productID, pushID: pushID, userID: userID), completion: { result in
                    switch result {
                    case .success(let response):
                        let json = try! JSON(data: response.data)
                        
                        let userID = try! json.getString(at: "userid")
                        if UserDefaults.standard.string(forKey: "userID") == nil {
                            UserDefaults.standard.set(userID, forKey: "userID")
                        }
                        
                        self.viewModel.updateProduct(with: json)
                    case .failure(let error):
                        Log.error?.message("Error while getting product information: \(error)")
                    }
                })
            })
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func registerForPush() {
        guard let pushToken = UserDefaults.standard.string(forKey: "PushDeviceToken") else {
            fatalError("No push device token found.")
        }
        
        if let userID = UserDefaults.standard.string(forKey: "UserID") {
            backendProvider.request(.getProfile(id: userID)) { result in
                switch result {
                case .success(let response):
                    guard let json = try? JSON(data: response.data) else {
                        print("Unable to parse JSON Response")
                        return
                    }
                    
                    guard let token = try? json.getString(at: "pushid") else {
                        print("Unable to find 'pushid' in: \(json)")
                        return
                    }
                    
                    if pushToken != token {
                        self.backendProvider.request(.updateProfile(id: try! json.getString(at: "id"),
                                                                    name: try! json.getString(at: "name"),
                                                                    avatar: try! json.getString(at: "avatar"),
                                                                    pushID: token, notificationActive: try! json.getBool(at: "notificationactive")))
                    }
                    
                case.failure(let error):
                    print("Erro while get user: \(error)")
                }
                
            }
        } else {
            backendProvider.request(.postProfile(name: UIDevice.current.identifierForVendor!.uuidString, avatar: "", pushID: pushToken, notificationActive: true)) { result in
                switch result {
                case .success(let response):
                    guard let json = try? JSON(data: response.data) else {
                        print("Unable to parse JSON Response")
                        return
                    }
                    guard let userID = try? json.getString(at: "id") else {
                        print("Unable to find user id in: \(json)")
                        return
                    }
                    
                    UserDefaults.standard.setValue(userID, forKey: "UserID")
                case .failure(let error):
                    print("Erro while post user: \(error)")
                }
            }
        }
    }
    
    private func showBarcodeScanner() {
        barcodeScannerController.navigationItem.setHidesBackButton(true, animated: false)
        barcodeScannerController.title = "Scan"
        navigationController.pushViewController(barcodeScannerController, animated: true)
    }
}

extension QRScannerTabViewCoordinator: BarcodeScannerCodeDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        Log.debug?.message("Received Barcode: \(code)")
        
        viewModel.qrContent.value = code
        
        //  The normal `.reset()` seems to be buggy / not working, so we use `.resetWithError()`
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
    
    func registerForRemotePush() {
        registerForPush()
    }
    
    /// Reset the tab and start scanning for QR codes again
    func didPressScanQRCodeButton() {
        start()
    }
    
    /// When the MachtSpassButton is being pressed, we send the question to the backend in order to trigger the push notifications
    func didPressMachtSpassButton() {
        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
        
        viewModel.productID
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
