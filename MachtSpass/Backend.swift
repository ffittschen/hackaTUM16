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
    case getProfile(String)
    case postProfile
    case updateProfile(String)
    case product(String)
    case postQuestion
    case pullQuestion(String)
    case getQuestion(String)
    case postAnswer
}

extension BackendService: TargetType {
    var baseURL: URL { return URL(string: "http://machtspass-server.azurewebsites.net/api/v1")! }
    
    var path: String {
        switch self {
        case .getProfile(let id):       return "/profile/\(id)"
        case .postProfile:              return "/profile"
        case .updateProfile(let id):    return "/profile/\(id)"
        case .product(let id):          return "/product/\(id)"
        case .postQuestion:             return "/question"
        case .pullQuestion(let id):     return "/question/\(id)/status"
        case .getQuestion(let id):      return "/question/\(id)"
        case .postAnswer:               return "/answer"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProfile:       return .get
        case .postProfile:      return .post
        case .updateProfile:    return .put
        case .product:          return .get
        case .postQuestion:     return .post
        case .pullQuestion:     return .get
        case .getQuestion:      return .get
        case .postAnswer:       return .post
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
        case .getProfile(_):
            return "{\"_id\": \"5827b7d26c92d1134dcd7f73\",\"updatedAt\": \"2016-11-13T00:46:11.136Z\",\"createdAt\": \"2016-11-13T00:46:11.136Z\",\"name\": \"Mrs. Sarina Dibbert\",\"avatar\": \"\",\"pushid\": \"\",\"notificationactive\": true,\"bucks\": 12,\"__v\": 0,\"id\": \"5827b7d26c92d1134dcd7f73\"}".data(using: .utf8)!
        case .postProfile:
            return "{\"__v\": 0,\"updatedAt\": \"2016-11-13T02:03:19.406Z\",\"createdAt\": \"2016-11-13T02:03:19.406Z\",\"name\":\"\",\"avatar\": \"\",\"pushid\": \"\",\"notificationactive\": true,\"bucks\": 0,\"_id\": \"5827c9e771103d1a1811ee62\",\"id\": \"5827c9e771103d1a1811ee62\"}".data(using: .utf8)!
            
        case .getQuestion(_):
            return "{\"_id\": \"5827b7d26c92d1134dcd7f73\",\"updatedAt\": \"2016-11-13T00:46:11.136Z\",\"createdAt\": \"2016-11-13T00:46:11.136Z\",\"name\": \"Mrs. Sarina Dibbert\",\"avatar\": \"\",\"pushid\": \"\",\"notificationactive\": true,\"bucks\": 12,\"__v\": 0,\"id\": \"5827b7d26c92d1134dcd7f73\"}".data(using: .utf8)!
        case .postQuestion:
            return "{\"_id\": \"5827b7d26c92d1134dcd7f73\",\"updatedAt\": \"2016-11-13T00:46:11.136Z\",\"createdAt\": \"2016-11-13T00:46:11.136Z\",\"name\": \"Mrs. Sarina Dibbert\",\"avatar\": \"\",\"pushid\": \"\",\"notificationactive\": true,\"bucks\": 12,\"__v\": 0,\"id\": \"5827b7d26c92d1134dcd7f73\"}".data(using: .utf8)!
        case .postAnswer:
            return "{\"_id\": \"5827b7d26c92d1134dcd7f73\",\"updatedAt\": \"2016-11-13T00:46:11.136Z\",\"createdAt\": \"2016-11-13T00:46:11.136Z\",\"name\": \"Mrs. Sarina Dibbert\",\"avatar\": \"\",\"pushid\": \"\",\"notificationactive\": true,\"bucks\": 12,\"__v\": 0,\"id\": \"5827b7d26c92d1134dcd7f73\"}".data(using: .utf8)!
        case .product(_):
            return "{\"_id\": \"5827b7d26c92d1134dcd7f73\",\"updatedAt\": \"2016-11-13T00:46:11.136Z\",\"createdAt\": \"2016-11-13T00:46:11.136Z\",\"name\": \"Mrs. Sarina Dibbert\",\"avatar\": \"\",\"pushid\": \"\",\"notificationactive\": true,\"bucks\": 12,\"__v\": 0,\"id\": \"5827b7d26c92d1134dcd7f73\"}".data(using: .utf8)!
        case .pullQuestion(_):
            return "{\"_id\": \"5827b7d26c92d1134dcd7f73\",\"updatedAt\": \"2016-11-13T00:46:11.136Z\",\"createdAt\": \"2016-11-13T00:46:11.136Z\",\"name\": \"Mrs. Sarina Dibbert\",\"avatar\": \"\",\"pushid\": \"\",\"notificationactive\": true,\"bucks\": 12,\"__v\": 0,\"id\": \"5827b7d26c92d1134dcd7f73\"}".data(using: .utf8)!
        case .updateProfile(_):
            return "{\"_id\": \"5827b7d26c92d1134dcd7f73\",\"updatedAt\": \"2016-11-13T00:46:11.136Z\",\"createdAt\": \"2016-11-13T00:46:11.136Z\",\"name\": \"Mrs. Sarina Dibbert\",\"avatar\": \"\",\"pushid\": \"\",\"notificationactive\": true,\"bucks\": 12,\"__v\": 0,\"id\": \"5827b7d26c92d1134dcd7f73\"}".data(using: .utf8)!
        }
        return Data()
    }
    
}
