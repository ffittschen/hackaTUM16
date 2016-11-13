//
//  AzureClient.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 12/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import MicrosoftAzureMobile

class AzureClient {
    
    // One-line Singleton
    static let shared = AzureClient()
    
    private(set) var client: MSClient
    
    private init () {
        client = MSClient(applicationURLString:"https://push-mobile-app.azurewebsites.net")
    }
}
