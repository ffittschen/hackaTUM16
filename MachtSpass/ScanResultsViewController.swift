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
import RxMoya
import Freddy

protocol ScanResultsViewControllerDelegate: class {
    func didPressScanQRCodeButton()
    func didTouchMakesFunButton()
}

class ScanResultsViewController: UIViewController {
    
    fileprivate let disposeBag: DisposeBag
    fileprivate let viewModel: ScanResultsViewModel
    
    weak var delegate: ScanResultsViewControllerDelegate?
    
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productDetailLabel: UILabel!
    @IBOutlet var funLevelMeter: GaugeView!
    @IBOutlet var productDetailsTableView: UITableView!
    
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
    
    func linkViewModel () {
        viewModel.productID.asObservable()
            .subscribe(onNext: { productID in
                RxMoyaProvider<BackendService>().request(.product(""), completion: { (response) in
                    guard let val = response.value else { return }
                    print("RES: \(val)")
                    let json = try! JSON(data: val.data)
                    
                    self.viewModel.productName.value = try! json.getString(at: "product", "title")
                    self.viewModel.productDescription.value = try! json.getString(at: "product", "content")
                    self.viewModel.productLikes.value = try! json.getInt(at: "product", "rating", "likes")
                    self.viewModel.productDislikes.value = try! json.getInt(at: "product", "rating", "dislikes")
                    self.viewModel.productFunLevel.value = try! json.getInt(at: "product", "rating", "funlevel")
                })
            })
            .addDisposableTo(disposeBag)
        
        viewModel
            .productNameValue
            .bindTo(UILabel(frame: .zero).rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .productDescriptionValue
            .bindTo(productDetailLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .productFunLevelValue
            .subscribe(onNext: { (funLevel) in
                self.funLevelMeter.progress = Double(funLevel)
            }).addDisposableTo(disposeBag)
        
        viewModel
            .productNameValue
            .bindTo(productNameLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .productNameValue
            .bindTo(productNameLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .productNameValue
            .bindTo(productNameLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productDetailsTableView.dataSource = self
        productDetailsTableView.delegate = self
        linkViewModel()
    }
}

//  Data source for detail table
extension ScanResultsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "DUMMY")
        cell.textLabel?.text = "DUMMY_CELL"
        return cell
    }
}

extension ScanResultsViewController: UITableViewDelegate {
    
}

