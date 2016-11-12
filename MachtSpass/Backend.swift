//
//  Backend.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 11/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import Moya

enum BackendService {
    case endpoint
}

extension BackendService: TargetType {
    var baseURL: URL { return URL(string: "https://example.org")! }
    
    var path: String {
        switch self {
        case .endpoint:
            return "/examples"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .endpoint:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    var task: Moya.Task {
        switch self {
        default:
            return .request
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        switch self {
        default:
            return nil
        }
    }
    
    var sampleData: Data {
        switch self {
        case .endpoint:
            return "{\"success\":true}".data(using: .utf8)!
        }
    }
    
}
