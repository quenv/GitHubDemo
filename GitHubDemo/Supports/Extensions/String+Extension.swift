//
//  StringExtension.swift
//  GitHubDemo
//
//  Created by QueNguyen on 6/22/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    // MARK: - Validate Password
    func isValidPassword() -> Bool {
        if self.isEmpty {
            return false
        }
        return has6Digit() && !hasAllSameDigit()
    }
    
    func has6Digit() -> Bool {
        return validatePassword(regex: "[0-9]{6}")
    }
    
    func hasAllSameDigit() -> Bool {
        return validatePassword(regex: "^(.)\\1*$")
    }
    
    private func validatePassword(regex: String) -> Bool{
        let passwordInput = NSPredicate(format:"SELF MATCHES %@", regex)
        return passwordInput.evaluate(with: self)
    }

}
