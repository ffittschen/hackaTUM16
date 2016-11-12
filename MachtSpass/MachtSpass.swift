//
//  MachtSpass.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 12/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation

struct MachtSpass {
    let productName: String
    let machtSpass: Bool
    
    enum MachtSpassJSONKey: String {
        case productName
        case machtSpass
    }
    
    init(productName: String, machtSpass: Bool) {
        self.productName = productName
        self.machtSpass = machtSpass
    }
    
    init?(userInfo: [AnyHashable : Any]) {
        guard let productName = userInfo[MachtSpassJSONKey.productName.rawValue] as? String,
              let machtSpass = userInfo[MachtSpassJSONKey.machtSpass.rawValue] as? Bool else {
                return nil
        }
        
        self.init(productName: productName, machtSpass: machtSpass)
    }
    
    func toUserInfo() -> [String: Any] {
        var userInfo = [String : Any]()
        
        userInfo[MachtSpassJSONKey.productName.rawValue] = productName
        userInfo[MachtSpassJSONKey.machtSpass.rawValue] = machtSpass
        
        return userInfo
    }
}
