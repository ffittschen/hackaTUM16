//
//  MachtSpass.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 12/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation


/// Model that holds the `Product` and the choice, if the `Product` makes fun
struct MachtSpass {
    let product: Product
    let machtSpass: Bool?
    
    enum MachtSpassJSONKey: String {
        case productName
        case productImageURL
        case machtSpass
    }
    
    init(product: Product, machtSpass: Bool? = nil) {
        self.product = product
        self.machtSpass = machtSpass
    }
    
    init?(userInfo: [AnyHashable : Any]) {
        guard let productName = userInfo[MachtSpassJSONKey.productName.rawValue] as? String,
              let productImage = userInfo[MachtSpassJSONKey.productImageURL.rawValue] as? String,
              let productImageURL = URL(string: productImage) else {
                return nil
        }
        
        let machtSpass = userInfo[MachtSpassJSONKey.machtSpass.rawValue] as? Bool
        let product = Product(name: productName, imageURL: productImageURL)
        
        self.init(product: product, machtSpass: machtSpass)
    }
    
    func toUserInfo() -> [String: Any] {
        var userInfo = [String : Any]()
        
        userInfo[MachtSpassJSONKey.productName.rawValue] = product.name
        userInfo[MachtSpassJSONKey.productImageURL.rawValue] = product.imageURL.absoluteString
        userInfo[MachtSpassJSONKey.machtSpass.rawValue] = machtSpass
        
        return userInfo
    }
}
