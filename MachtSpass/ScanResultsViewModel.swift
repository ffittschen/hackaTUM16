//
//  ScanResultsViewModel.swift
//  HackaTUM
//
//  Created by Peter Christian Glade on 12.11.16.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import RxSwift

struct ScanResultsViewModel {
    fileprivate let disposeBag: DisposeBag
    let qrContent: Variable<String?>
    let productID: Observable<Int>
    
    init() {
        disposeBag = DisposeBag()
        
        qrContent = Variable<String?>(nil)
        productID = qrContent.asObservable()
            .map({ qrContent -> Int? in
                guard let qrContent = qrContent,
                    let productID = Int(qrContent) else {
                        return nil
                }
                
                return productID
            })
            .ignoreNil()
    }
}
