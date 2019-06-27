//
//  LoginViewModel.swift
//  GitHubDemo
//
//  Created by QueNguyen on 6/21/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let usernameTrigger: Driver<String>
        let passwordTrigger: Driver<String>
        let tapLoginTrigger: Driver<Void>
    }
    
    struct Output {
        let loginButtonEnabled: Driver<Bool>
    }
    
    private let disposeBag = DisposeBag()
    let username = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    let isValidUserName = BehaviorRelay<Bool>(value: false)
    
    func transform(input: Input) -> Output {
        let usernameTrigged = input.usernameTrigger
        let passwordTrigged = input.passwordTrigger
        let tapLogin = input.tapLoginTrigger
        
        usernameTrigged.drive(onNext: { [weak self] username in
                guard let self = self else { return }
                self.validateUsername(username)
                self.username.accept(username)
            })
            .disposed(by: disposeBag)
        
        let loginButtonEnabled = BehaviorRelay.combineLatest(isValidUserName.asObservable(), passwordTrigged.asObservable()) {
            self.password.accept($1)
            return $0 && $1.isValidPassword()
            }.asDriver(onErrorJustReturn: false)
        
        tapLogin.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.saveUserInfo()
        }).disposed(by: disposeBag)
        
        
        return Output(loginButtonEnabled: loginButtonEnabled)
    }
    
    func validateUsername(_ username: String) {
        
        if username.isEmpty || hasInvalidUsername(username) {
            isValidUserName.accept(false)
            return
        }
        if hasValidUsername(username) {
            isValidUserName.accept(true)
            return
        }
        self.provider.searchUsers(query: username).subscribe(onNext: { [weak self] (result, status) in
            guard let self = self else { return }
            if status == .invalidData {
                self.updateInvalidUsernames(username)
                self.isValidUserName.accept(false)
                return
            }
            if status == .success, let usernames = result {
                self.updateValidUsernames(usernames)
                let isValidUser = self.hasValidUsername(username)
                self.isValidUserName.accept(isValidUser)
                return
            }
            self.isValidUserName.accept(false)
            
        }).disposed(by: disposeBag)
        
        
    }
    
    func updateValidUsernames(_ usernames: [User]) {
        var currentValidArr = DBManager.shared().validUsernames
        for username in usernames {
            if let account = username.login, !currentValidArr.contains(account) {
                currentValidArr.append(account)
            }
        }
        DBManager.shared().validUsernames = currentValidArr
        DBManager.shared().synchronize()
    }
    
    func hasValidUsername(_ name: String) -> Bool {
        return DBManager.shared().validUsernames.contains(name)
    }
    
    func updateInvalidUsernames(_ name: String) {
        var currentInvalidArr = DBManager.shared().invalidUsernames
        if !currentInvalidArr.contains(name) {
            currentInvalidArr.append(name)
        }
        DBManager.shared().invalidUsernames = currentInvalidArr
        DBManager.shared().synchronize()
    }
    
    func hasInvalidUsername(_ name: String) -> Bool {
        return DBManager.shared().invalidUsernames.contains(name)
    }
    
    func saveUserInfo() {
        let user = User(login: username.value, password: password.value)
        user.save()
    }
   
}

