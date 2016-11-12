//
//  FirstTabViewController.swift
//  HackaTUM
//
//  Created by Florian Fittschen on 11/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FirstTabViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    fileprivate let disposeBag: DisposeBag
    fileprivate let viewModel: FirstTabViewModel
    
    init(viewModel: FirstTabViewModel) {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

