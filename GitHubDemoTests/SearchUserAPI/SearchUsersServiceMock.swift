//
//  SearchUsersServiceMock.swift
//  GitHubDemoTests
//
//  Created by Macbook on 6/24/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
@testable import GitHubDemo

class SearchUsersServiceMock: SearchUserAPI {
    
    func searchUsers(query: String) -> Observable<([User]?, ResponseStatus)> {
        var response = [String: Any]()
        let bundle = Bundle(for: SearchUsersServiceMock.self)
        if let path = bundle.path(forResource: "searchUserResponse", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                if let json = json as? [String: Any] {
                    response = json
                }

            } catch {
                return Observable.just((nil, .error))
            }
        }
        guard let model = UserSearch(JSON: response) else {
            return Observable.just((nil, .error))
        }
        if model.totalCount > 0 {
            return Observable.just((model.items, .success))
        } else {
            return Observable.just((nil, .invalidData))
        }
      
    }
}
