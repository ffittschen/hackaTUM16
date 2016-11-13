//
//  ScanResultsViewModel.swift
//  HackaTUM
//
//  Created by Peter Christian Glade on 12.11.16.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxMoya
import Freddy

struct ScanResultsViewModel {
    fileprivate let disposeBag: DisposeBag
    let qrContent: Variable<String?>
    let productID: Observable<Int>
    
    let productImage = Variable<UIImage?>(nil)
    let productName = Variable<String>("")
    let productDescription = Variable<String>("")
    let productLikes = Variable<Int>(0)
    let productDislikes = Variable<Int>(0)
    let productFunLevel = Variable<Int>(0)
    
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

extension ScanResultsViewModel {
    var productImageValue: Observable<UIImage?> {
        return productImage.asObservable()
    }
    
    var productNameValue: Observable<String> {
        return productName.asObservable()
    }

    var productDescriptionValue: Observable<String> {
        return productDescription.asObservable()
    }

    var productLikesValue: Observable<Int> {
        return productLikes.asObservable()
    }

    var productDislikesValue: Observable<Int> {
        return productDislikes.asObservable()
    }

    var productFunLevelValue: Observable<Int> {
        return productFunLevel.asObservable()
    }

}

