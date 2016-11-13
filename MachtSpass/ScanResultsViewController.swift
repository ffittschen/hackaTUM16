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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productDetailsTableView.dataSource = self
        productDetailsTableView.delegate = self
        
        viewModel.productID.asObservable()
            .subscribe(onNext: { productID in
                Log.debug?.message("TODO: fetch data for ID and init product")
            })
            .addDisposableTo(disposeBag)
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

