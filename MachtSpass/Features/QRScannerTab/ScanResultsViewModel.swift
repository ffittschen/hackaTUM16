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
    fileprivate let productImage: Variable<UIImage?>
    fileprivate let productName: Variable<String>
    fileprivate let productDescription: Variable<String>
    fileprivate let productLikes: Variable<Int>
    fileprivate let productDislikes: Variable<Int>
    fileprivate let productFunLevel: Variable<Int>
    
    let qrContent: Variable<String?>
    let productID: Observable<String>
    
    init() {
        disposeBag = DisposeBag()
        productImage = Variable<UIImage?>(nil)
        productName = Variable<String>("")
        productDescription = Variable<String>("")
        productLikes = Variable<Int>(0)
        productDislikes = Variable<Int>(0)
        productFunLevel = Variable<Int>(0)
        
        qrContent = Variable<String?>(nil)
        productID = qrContent.asObservable()
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
    
    
    /// Fill all `value`s of the `ScanResultsViewModel` using the `JSON`
    ///
    /// - Parameter json: a `JSON` containing all relevant `value`s. The `json` usually is provided by the backend.
    func updateProduct(with json: JSON) {
        productName.value = try! json.getString(at: "product", "title")
        productDescription.value = try! json.getString(at: "product", "content")
        productLikes.value = try! json.getInt(at: "rating", "likes")
        productDislikes.value = try! json.getInt(at: "rating", "dislikes")
        productFunLevel.value = try! json.getInt(at: "rating", "funfactor")
        
        if let imageURL = URL(string: try! json.getString(at: "product", "image")) {
            let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.sync() {
                    self.productImage.value = UIImage(data: data)
                }
            }.resume()
        }
    }

}

