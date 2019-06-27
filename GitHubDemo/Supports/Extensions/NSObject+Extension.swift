//
//  NSObjectExtension.swift
//  GitHubDemo
//
//  Created by QueNguyen on 06/22/19.
//  Copyright © 2018 QueNguyen. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
