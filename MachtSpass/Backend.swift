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
    case getProfile(id: String)
    case postProfile(name: String, avatar: String, pushID: String, notificationActive: Bool)
    case updateProfile(id: String)
    case product(id: String, pushID: String, userID: String)
    case postQuestion(userID: String, productID: String)
    case pullQuestion(id: String)
    case getQuestion(id: String)
    case postAnswer
}

extension BackendService: TargetType {
    var baseURL: URL { return URL(string: "https://machtspass-api.azurewebsites.net/api/v1")! }
    
    var path: String {
        switch self {
        case .getProfile(let id):    return "/profile/\(id)"
        case .postProfile:           return "/profile"
        case .updateProfile(let id): return "/profile/\(id)"
        case .product:               return "/product"
        case .postQuestion:          return "/question"
        case .pullQuestion(let id):  return "/question/\(id)/status"
        case .getQuestion(let id):   return "/question/\(id)"
        case .postAnswer:            return "/answer"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProfile,
             .pullQuestion,
             .getQuestion:
            return .get
        case .postProfile,
             .product,
             .postQuestion,
             .postAnswer:
            return .post
        case .updateProfile:
            return .put
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .postProfile(let name, let avatar, let pushID, let notificationActive):
            return [
                "name": name,
                "avatar": avatar,
                "pushid": pushID,
                "notificationactive": notificationActive
            ]
        case .product(let id, let pushID, let userID):
            return [
                "productid": id,
                "pushid": pushID,
                "userid": userID
            ]
        case .postQuestion(let userID, let productID):
            return [
                "userid": userID,
                "productid": productID,
                "latitude": "",
                "longitude": ""
            ]
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
    }    
}
