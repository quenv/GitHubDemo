//
//  GitHubAPI.swift
//  GitHubDemo
//
//  Created by SmartOSC on 6/25/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

enum GithubAPI {
    case searchRepositories(query: String)
    case searchUsers(query: String)
}

extension GithubAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Configs.Network.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .searchRepositories: return "/search/repositories"
        case .searchUsers: return "/search/users"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .searchRepositories(let query):
            params["q"] = query
        case .searchUsers(let query):
            params["q"] = query
        }
        return params
    }
    
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var task: Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
        return .requestPlain
    }
    
    var sampleData: Data {
        //TODO: create fake data to test
        return Data()
    }

}

