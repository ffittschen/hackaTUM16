//
//  Product.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 12/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation

struct Product {
    let name: String
    let imageURL: URL
    
    init(name: String, imageURL: URL) {
        self.name = name
        self.imageURL = imageURL
    }
}
