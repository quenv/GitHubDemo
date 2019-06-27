//
//  BaseViewController.swift
//  GitHubDemo
//
//  Created by Macbook on 6/27/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, Navigatable {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var viewModel: ViewModel?
    var navigator: Navigator!
    
    init(nibName: String, viewModel: ViewModel?, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
