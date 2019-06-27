//
//  Repository.swift
//  GitHubDemo
//
//  Created by SmartOSC on 6/25/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation
import ObjectMapper

class Repository: Mappable {
    
    var id: Int = 0
    var fullname: String = ""
    var description: String  = ""
    var forksCount: Int = 0
    var starsCount: Int = 0
    var language: String = ""
    var updatedTime: String = ""
    var isMarked: Bool = false

    required init?(map: Map) {}
    init() {}
    
    func mapping(map: Map) {
        id <- map["id"]
        fullname <- map["full_name"]
        description <- map["description"]
        forksCount <- map["forks_count"]
        starsCount <- map["stargazers_count"]
        language <- map["language"]
        updatedTime <- map["updated_at"]
        isMarked <- map["isMarked"]
    }
    
    func getDictionary() -> [String : Any] {
        let dict: [String : Any] = [
            "id": id,
            "full_name" : fullname,
            "description" : description,
            "stargazers_count" : starsCount,
            "forks_count" : forksCount,
            "language" : language,
            "updated_at" : updatedTime,
             "isMarked" : isMarked
        ]
        return dict
    }
 
}

extension Repository: Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.fullname == rhs.fullname
    }
}

struct RepositorySearch: Mappable {
    
    var items: [Repository] = []
    var totalCount: Int = 0
    var incompleteResults: Bool = false
    
    init?(map: Map) {}
    init() {}
    
    init(items: [Repository], totalCount: Int, incompleteResults: Bool) {
        self.items = items
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
    }
    
    mutating func mapping(map: Map) {
        items <- map["items"]
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
    }
}
