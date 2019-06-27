//
//  User.swift
//  GitHubDemo
//
//  Created by SmartOSC on 6/25/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation
import ObjectMapper
import KeychainAccess

private let userKey = "CurrentUserKey"
private let keychain = Keychain(service: Configs.App.bundleIdentifier)


struct User: Mappable {
    
    var login: String?
    var password: String = ""
    
    init?(map: Map) {}
    init() {}
    
    init(login: String?, password: String) {
        self.login = login
        self.password = password
    }
    
    mutating func mapping(map: Map) {
        login <- map["login"]
        password <- map["password"]
    }
}


extension User {
    func save() {
        if let json = self.toJSONString() {
            keychain[userKey] = json
        } else {
            logDebug("User can't be saved")
        }
    }
    
    static func currentUser() -> User? {
        if let json = keychain[userKey], let user = User(JSONString: json) {
            return user
        }
        return nil
    }
    
    static func removeCurrentUser() {
        keychain[userKey] = nil
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.login == rhs.login
    }
}

struct UserSearch: Mappable {
    
    var items: [User] = []
    var totalCount: Int = 0
    var incompleteResults: Bool = false
    
    init?(map: Map) {}
    init() {}
    
    mutating func mapping(map: Map) {
        items <- map["items"]
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
    }
}
