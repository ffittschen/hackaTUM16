//
//  ScanResultsViewController.swift
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

protocol ScanResultsViewControllerDelegate {
    func didTouchMakesFunButton()
}

class ScanResultsViewController: UIViewController {
    
    fileprivate let disposeBag: DisposeBag
    fileprivate let viewModel: ScanResultsViewModel
    
    var delegate: ScanResultsViewControllerDelegate!
    
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productDetailLabel: UILabel!
    @IBOutlet var funLevelMeter: GaugeView!
    @IBOutlet var productDetailsTableView: UITableView!
    
    init(viewModel: ScanResultsViewModel) {
        self.viewModel = viewModel
        self.delegate = viewModel
        
        disposeBag = DisposeBag()
        
        super.init(nibName: R.nib.scanResultsViewController.name, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productDetailsTableView.dataSource = self.viewModel
        productDetailsTableView.delegate = self.viewModel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
