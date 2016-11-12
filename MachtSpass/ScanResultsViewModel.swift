//
//  ScanResultsViewModel.swift
//  HackaTUM
//
//  Created by Peter Christian Glade on 12.11.16.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import RxSwift
import QRCodeReader
import AVFoundation

class ScanResultsViewModel: NSObject {
    fileprivate let disposeBag: DisposeBag
    
    let productID: String
    
    init(productID: String) {
        self.productID = productID
        disposeBag = DisposeBag()
    }
}

extension ScanResultsViewModel {
    
}

//  Data source for detail table
extension ScanResultsViewModel: UITableViewDataSource {
    
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

extension ScanResultsViewModel: UITableViewDelegate {
    
}
