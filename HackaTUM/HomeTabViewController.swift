//
//  HomeTabViewController.swift
//  HackaTUM
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
        
        viewModel.funBucks
            .map { intValue -> String? in
                return "\(intValue)"
            }
            .bindTo(funBucks.rx.text)
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

