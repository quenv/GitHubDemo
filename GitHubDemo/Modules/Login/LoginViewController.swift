//
//  LoginViewController.swift
//  GitHubDemo
//
//  Created by QueNguyen on 6/21/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import RxCocoa

class LoginViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    let disposeBag = DisposeBag()
   
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Localizable.kLogin.localized()
        userNameTextField.delegate = self
        bindingData()

      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - SetupView
    private func bindingData() {
        guard let viewModel = viewModel as? LoginViewModel else { return }

        let input = LoginViewModel.Input(usernameTrigger: userNameTextField.rx.text.orEmpty.throttle(.milliseconds(300), scheduler: MainScheduler.instance).asDriverOnErrorJustComplete(),
                                         passwordTrigger: passwordTextField.rx.text.orEmpty.asDriver(),
                                         tapLoginTrigger: loginButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        output.loginButtonEnabled.drive(loginButton.rx.isEnabled).disposed(by: disposeBag)

        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.dismissKeyboard()
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
    
    // MARK: - Action
    @IBAction func onClickLogin(_ sender: UIButton){
        dismissKeyboard()
        self.navigator.show(segue: .main, sender: self, transition: .root(in: self.appDelegate.window!))
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.becomeFirstResponder()
        return true
    }
}

