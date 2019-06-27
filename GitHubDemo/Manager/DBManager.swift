//
//  UserManager.swift
//  GitHubDemo
//
//  Created by Macbook on 6/22/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation

class DBManager: GDUserDefaults {
    
    private let RECENT_KEY             = "___RECENT_KEY___"
    private let FAVORITE_KEY           = "___FAVORITE_KEY___"
    private let USERNAME_KEY           = "___USERNAME_KEY___"
    private let PASSWORD_KEY           = "___PASSWORD_KEY___"
    private let IS_LOGIN_KEY           = "___IS_LOGIN_KEY___"
    private let VALID_USERNAMES_KEY    = "___VALID_USERNAMES_KEY___"
    private let INVALID_USERNAMES_KEY  = "___INVALID_USERNAMES_KEY___"
    
    private static var sharedInstance = DBManager()
    
    override static func shared() -> DBManager {
        return sharedInstance
    }
    
    var validUsernames: [String] {
        get {
            return getDataObject(VALID_USERNAMES_KEY) as? [String] ?? []
        }
        set {
            set(newValue, forKey: VALID_USERNAMES_KEY)
        }
    }
    
    var invalidUsernames: [String] {
        get {
            return getDataObject(INVALID_USERNAMES_KEY) as? [String] ?? []
        }
        set {
            set(newValue, forKey: INVALID_USERNAMES_KEY)
        }
    }
    
    var favoriteList: [Repository] {
        get {
            guard let jsonString = getDataObject(FAVORITE_KEY) as? String else {
                return []
            }
            return convertJSONToDict(jsonString)
        }
        set {
            let jsonString = convertDictToJSON(newValue)
            set(jsonString, forKey: FAVORITE_KEY)
        }
    }
    
    var recentDict: [String : Any] {
        get {
            return getDataObject(RECENT_KEY) as? [String : Any] ?? [:]
        }
        set {
            set(newValue, forKey: RECENT_KEY)
        }
    }
    
    
}


