//
//  QRScannerTabViewController.swift
//  MachtSpass
//
//  Created by Peter Christian Glade on 12.11.16.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import QRCodeReader

class QRScannerTabViewController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel!
    
    fileprivate let disposeBag: DisposeBag
    fileprivate let viewModel: QRScannerTabViewModel
    
    private lazy var readerVC = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
    })

    init(viewModel: QRScannerTabViewModel) {
        self.viewModel = viewModel
        
        disposeBag = DisposeBag()
        
        super.init(nibName: R.nib.qRScannerTabViewController.name, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  just for debugging on the simulator which has no camera
        if UIDevice.isSimulator {
            self.viewModel.testPseudoQRCode()
        } else {
            
            //  Add and expand qrCodeScan View
            self.view.addSubview(readerVC.view)
            self.view.leadingAnchor.constraint(equalTo: readerVC.view.leadingAnchor).isActive = true
            self.view.trailingAnchor.constraint(equalTo: readerVC.view.trailingAnchor).isActive = true
            self.view.layoutMarginsGuide.topAnchor.constraint(equalTo: readerVC.view.topAnchor).isActive = true
            self.view.layoutMarginsGuide.bottomAnchor.constraint(equalTo: readerVC.view.bottomAnchor).isActive = true
        
            //  Start scanning 
            readerVC.delegate = self.viewModel
            readerVC.startScanning()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
