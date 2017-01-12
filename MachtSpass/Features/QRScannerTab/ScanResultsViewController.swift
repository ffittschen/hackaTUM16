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
import CleanroomLogger

protocol ScanResultsViewControllerDelegate: class {
    func didPressScanQRCodeButton()
    func didPressMachtSpassButton()
    func registerForRemotePush()
}

class ScanResultsViewController: UIViewController {
    
    @IBOutlet weak var machtSpassButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDetailLabel: UILabel!
    @IBOutlet weak var funLevelMeter: GaugeView!
    @IBOutlet weak var dislikeLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    fileprivate let disposeBag: DisposeBag
    fileprivate let viewModel: ScanResultsViewModel
    
    weak var delegate: ScanResultsViewControllerDelegate?
    
    init(viewModel: ScanResultsViewModel) {
        self.viewModel = viewModel
        
        disposeBag = DisposeBag()
        
        super.init(nibName: R.nib.scanResultsViewController.name, bundle: nil)
        
        let rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ScanTabIcon"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationBar.tintColor = UIColor(hex: "#df0000")
        
        rightBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] () in
                self?.delegate?.didPressScanQRCodeButton()
            })
            .addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        funLevelMeter.stops = [
            (0.0, UIColor.red),
            (0.25, UIColor.orange),
            (0.5, UIColor.yellow),
            (0.75, UIColor.green)
        ]
        
        linkViewModel()
        delegate?.registerForRemotePush()
    }
    
    private func linkViewModel() {
        viewModel
            .productNameValue
            .bindTo(productNameLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .productDescriptionValue
            .bindTo(productDetailLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .productImageValue
            .bindTo(productImageView.rx.image)
            .addDisposableTo(disposeBag)
        
        viewModel
            .productFunLevelValue
            .subscribe(onNext: { (funLevel) in
                self.funLevelMeter.progress = Double(funLevel)/100
            }).addDisposableTo(disposeBag)
        
        viewModel
            .productDislikesValue
            .map { dislikes -> String? in
                return "\(dislikes)"
            }
            .bindTo(dislikeLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .productLikesValue
            .map { likes -> String? in
                return likes.description
            }
            .bindTo(likeLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        machtSpassButton.rx.tap
            .subscribe(onNext: { [weak self] () in
                self?.delegate?.didPressMachtSpassButton()
            })
            .addDisposableTo(disposeBag)
    }
}
