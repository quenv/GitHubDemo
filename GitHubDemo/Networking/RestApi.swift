//
//  RestApi.swift
//  GitHubDemo
//
//  Created by Macbook on 6/25/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
import Moya
import Alamofire
import Moya_ObjectMapper

enum Result<T> {
    case success(T)
    case error(Error)
}

enum ResponseStatus {
    case success
    case invalidData
    case error
}

struct RestApi: RouterAPI {

    private static let provider = MoyaProvider<GithubAPI>()
    
    private func baseRequest(_ target: GithubAPI) -> Observable<Result<Any>> {
        return Observable.create({ observer -> Disposable in
           RestApi.provider.manager.session.configuration.timeoutIntervalForRequest = 10
            RestApi.provider.request(target, completion: { (response) in
                switch response.result {
                case .success(let value):
                    do {
                         let json = try value.mapJSON()
                         observer.onNext(Result.success(json))
                    } catch (let err){
                        observer.onNext(Result.error(err))
                    }
                case .failure(let error):
                    observer.onNext(Result.error(error))
                }
                observer.onCompleted()
            })
           
            return Disposables.create()
        })
    }
    
}

extension RestApi {
   
    func searchRepositories(query: String) -> Observable<([Repository]?, ResponseStatus)> {
        return baseRequest(.searchRepositories(query: query)).flatMapLatest { resultJson -> Observable<([Repository]?, ResponseStatus)> in
            switch resultJson {
            case .success(let json):
                if let array = json as? [String: AnyObject] {
                    guard let model = RepositorySearch(JSON: array) else {
                        return Observable.just((nil, .error))
                    }
                    if model.totalCount > 0 {
                        return Observable.just((model.items, .success))
                    } else {
                        return Observable.just((nil, .invalidData))
                    }
                }
                return Observable.just((nil, .error))
            case .error:
                return Observable.just((nil, .error))
            }
        }
    }
    
    func searchUsers(query: String) -> Observable<([User]?, ResponseStatus)> {
        return baseRequest(.searchUsers(query: query)).flatMapLatest { resultJson -> Observable<([User]?, ResponseStatus)> in
            switch resultJson {
            case .success(let json):
                if let array = json as? [String: AnyObject] {
                    guard let model = UserSearch(JSON: array) else {
                        return Observable.just((nil, .error))
                    }
                    if model.totalCount > 0 {
                        return Observable.just((model.items, .success))
                    } else {
                        return Observable.just((nil, .invalidData))
                    }
                }
                return Observable.just((nil, .error))
            case .error:
                return Observable.just((nil, .error))
            }
        }
    }

}


