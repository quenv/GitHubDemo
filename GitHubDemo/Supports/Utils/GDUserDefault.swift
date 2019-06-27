//
//  GDUserDefault.swift
//  GitHubDemo
//
//  Created by Macbook on 6/22/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation

class TMUserDefaults: UserDefaults {
    private static let sharedInstanceVar = TMUserDefaults()
    
    class func sharedInstance() -> TMUserDefaults {
        return sharedInstanceVar
    }
    
    override func set(_ value: Any?, forKey key: String) {
        var data: Data?
        if let value = value {
            data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        }
        standardUserDefaults().set(data, forKey: getKey(ForString: key))
    }
    
    func getKey(ForString originalKey: String) -> String {
        return className + originalKey
    }
    
    func standardUserDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    func getObject(_ key: String) -> Any? {
        let value = standardUserDefaults().object(forKey: getKey(ForString: key))
        if let data = value as? Data {
            do {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            } catch {
                return nil
            }
        } else {
            return value
        }
    }
    
    func getArray(_ key: String) -> [Any]? {
        guard let data = standardUserDefaults().object(forKey: getKey(ForString: key)) as? Data else { return nil }
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Any]
        } catch {
            return nil
        }
    }
}
