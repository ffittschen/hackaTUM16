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

protocol HomeTabViewControllerDelegate {
    func didPressRedeem()
    func didPressGift()
}

class HomeTabViewController: UIViewController {

    @IBOutlet weak var funBucks: UILabel!
    @IBOutlet weak var redeemButton: UIButton!
    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    fileprivate let disposeBag: DisposeBag
    fileprivate let viewModel: HomeTabViewModel
    
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
        
        // Calculate the top constraint, using the statusBarHeight and the navigationBarHeight
        topConstraint.constant = UIApplication.shared.statusBarFrame.height + 8
        
        if let height = navigationController?.navigationBar.bounds.height {
            topConstraint.constant = topConstraint.constant + height
        }
        
        // RxSwift
        viewModel.funBucks
            .map { intValue -> String? in
                return "\(intValue)"
            }
            .bindTo(funBucks.rx.text)
            .addDisposableTo(disposeBag)
    }
}

