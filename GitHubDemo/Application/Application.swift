//
//  Application.swift
//  GitHubDemo
//
//  Created by Macbook on 6/26/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import UIKit

final class Application: NSObject {
    static let shared = Application()
    
    var window: UIWindow?
    let navigator: Navigator

    private override init() {
        navigator = Navigator.default
        super.init()
    }
    
    func presentInitialScreen(in window: UIWindow?) {
        guard let window = window else { return }
        self.window = window
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if let _ = User.currentUser() {
                //show mainview
                self.navigator.show(segue: .main, sender: nil, transition: .root(in: window))
                return
            }
            //show loginview
            self.navigator.show(segue: .login, sender: nil, transition: .root(in: window))
        }
    }

}
