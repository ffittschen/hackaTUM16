//
//  HomeTabViewController.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 11/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeTabViewControllerDelegate: class {
    func didPressRedeem()
    func didPressGift()
}

class HomeTabViewController: UIViewController {

    @IBOutlet weak var funBucks: UILabel!
    @IBOutlet weak var redeemButton: UIButton!
    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var testNotificationButton: UIButton!
    
    fileprivate let disposeBag: DisposeBag
    fileprivate let viewModel: HomeTabViewModel
    
    weak var delegate: HomeTabViewControllerDelegate?
    
    init(viewModel: HomeTabViewModel) {
        self.viewModel = viewModel
        
        disposeBag = DisposeBag()
        
        super.init(nibName: R.nib.homeTabViewController.name, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Calculate the top constraint, using the statusBarHeight and the navigationBarHeight
        topConstraint.constant = UIApplication.shared.statusBarFrame.height + 8
        
        if let height = navigationController?.navigationBar.bounds.height {
            topConstraint.constant = topConstraint.constant + height
        }
        
        //  RxSwift bindings
        viewModel.funBucks
            .map { intValue -> String? in
                return "\(intValue)"
            }
            .bindTo(funBucks.rx.text)
            .addDisposableTo(disposeBag)
        
        redeemButton.rx.tap
            .subscribe(onNext: { [weak self] event in
                self?.delegate?.didPressRedeem()
            })
            .addDisposableTo(disposeBag)
        
        giftButton.rx.tap
            .subscribe(onNext: { [weak self] event in
                self?.delegate?.didPressGift()
            })
            .addDisposableTo(disposeBag)
        
        testNotificationButton.rx.tap
            .subscribe(onNext: { event in
                if let imageURL = Bundle.main.url(forResource: "AirPods", withExtension: "jpg") {
                    let product = Product(name: "Apple AirPods", imageURL: imageURL)
                    NotificationHandler.scheduleNotification(for: MachtSpass(product: product, machtSpass: false), delay: 3)
                }
                
            })
            .addDisposableTo(disposeBag)
    }
}

