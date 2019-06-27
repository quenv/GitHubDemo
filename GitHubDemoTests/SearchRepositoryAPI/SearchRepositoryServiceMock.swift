//
//  SearchRepositoryServiceMock.swift
//  GitHubDemoTests
//
//  Created by Macbook on 6/25/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
@testable import GitHubDemo

class SearchRepositoryServiceMock: SearchRepositorieAPI {
    
    
    
    func searchRepositories(query: String) -> Observable<([Repository]?, ResponseStatus)> {
        var response = [String: Any]()
        let bundle = Bundle(for: SearchRepositoryServiceMock.self)
        if let path = bundle.path(forResource: "searchRepositoryResponse", ofType: "json") {
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
        guard let model = RepositorySearch(JSON: response) else {
            return Observable.just((nil, .error))
        }
        if model.totalCount > 0 {
            return Observable.just((model.items, .success))
        } else {
            return Observable.just((nil, .invalidData))
        }
    }
}
