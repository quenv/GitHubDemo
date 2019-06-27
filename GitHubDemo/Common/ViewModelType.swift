//
//  ViewModelType.swift
//  GitHubDemo
//
//  Created by SmartOSC on 6/25/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
import Moya

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class ViewModel: NSObject {
    
    let provider : RouterAPI
    
    override init() {
        self.provider = RestApi()
        super.init()    
    }
    
}
