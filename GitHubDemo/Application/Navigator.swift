//
//  Navigator.swift
//  GitHubDemo
//
//  Created by Macbook on 6/27/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()
    
    // MARK: - segues list, all app scenes
    enum Scene {
        case login
        case main
        case detail(model: Repository)
    }
    
    enum Transition {
        case root(in: UIWindow)
        case push
        case custom
    }
    
    // MARK: - get a single VC
    func get(segue: Scene) -> UIViewController? {
        switch segue {
        case .login:
            let loginVC = LoginViewController(nibName: LoginViewController.className,
                                              viewModel: LoginViewModel(),
                                              navigator: self)
            return loginVC
        case .main:
            let mainVC = MainViewController(nibName: MainViewController.className,
                                            viewModel: MainViewModel(mode: .normal),
                                            navigator: self)
            return mainVC
        case .detail(let model):
            let detailVC = DetailViewController(nibName: DetailViewController.className,
                                                viewModel: DetailViewModel(repository: model),
                                                navigator: self)
            return detailVC
        }
    }
    
    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController(animated: true)
        }
    }
    
    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func show(segue: Scene, sender: UIViewController?, transition: Transition) {
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root(in: let window):
            
            UIView.transition(with: window, duration: 0.2, options: .curveLinear, animations: {
                let naviController = UINavigationController(rootViewController: target)
                window.rootViewController = naviController
            }, completion: nil)
            return
        default: break
        }
        
        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation transitions")
        }
        
        switch transition {
            case .push:
            if let nav = sender.navigationController {
                // push controller to navigation stack
                nav.pushViewController(target, animated: true)
            }
            default: break
        }
    }
    
    
}
