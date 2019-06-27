//
//  Api.swift
//  GitHubDemo
//
//  Created by SmartOSC on 6/25/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation
import RxSwift

protocol RouterAPI {
    func searchUsers(query: String) ->  Observable<([User]?, ResponseStatus)>
    func searchRepositories(query: String) ->  Observable<([Repository]?, ResponseStatus)>
}

protocol SearchRepositorieAPI {
    func searchRepositories(query: String) ->  Observable<([Repository]?, ResponseStatus)>
}

protocol SearchUserAPI {
    func searchUsers(query: String) ->  Observable<([User]?, ResponseStatus)>
}

