//
//  GDUserDefaults.swift
//  GitHubDemo
//
//  Created by Macbook on 6/22/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation

class GDUserDefaults: UserDefaults {
    
    private static let sharedInstance = GDUserDefaults()
    
    class func shared() -> GDUserDefaults {
        return sharedInstance
    }
    
    override func set(_ value: Any?, forKey key: String) {
        var data: Data?
        if let dataValue = value {
            do {
                data = try NSKeyedArchiver.archivedData(withRootObject: dataValue, requiringSecureCoding: false)
            }catch{}
        }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func getDataArray(_ key: String) -> [Any]? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Any]
        } catch {
            return nil
        }
    }
    
    func getDataObject(_ key: String) -> Any? {
        let data = UserDefaults.standard.object(forKey: key)
        if let dataValue = data as? Data {
            do {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataValue)
            } catch {
                return data
            }
        } else {
            return data
        }
    }
    
    func convertDictToJSON(_ array: [Repository]) -> String {
        var jsonString = ""
        var dict: [[String: Any]] = []
        for item in array {
            dict.append(item.getDictionary())
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            if let content = String(data: jsonData, encoding: .utf8) {
                jsonString = content
            }
        } catch {}
        return jsonString
    }
    
    func convertJSONToDict(_ jsonData: String) -> [Repository] {
        var result = [Repository]()
        let data = jsonData.data(using: .utf8)!
        do {
            guard let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [[String: Any]] else { return result}
            for item in array {
                if let repo = Repository(JSON: item) {
                    result.append(repo)
                }
            }
        } catch let error as NSError {
            logDebug(error.localizedDescription)
        }
        return result
    }
    
}
