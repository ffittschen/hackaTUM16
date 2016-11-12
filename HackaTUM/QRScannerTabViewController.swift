//
//  QRScannerTabViewController.swift
//  HackaTUM
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
        
        super.init(nibName: R.nib.firstTabViewController.name, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.stringValue
            .bindTo(testLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        self.view.addSubview(readerVC.view)
        self.view.leadingAnchor.constraint(equalTo: readerVC.view.leadingAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: readerVC.view.trailingAnchor).isActive = true
        self.view.topAnchor.constraint(equalTo: readerVC.view.topAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: readerVC.view.bottomAnchor).isActive = true
        
        readerVC.delegate = self.viewModel
        readerVC.startScanning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
