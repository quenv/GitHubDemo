//
//  DetailViewController.swift
//  GitHubDemo
//
//  Created by Macbook on 6/22/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DetailViewController: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    var deleteButton: UIBarButtonItem!
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingData()
    }
    
    //MARK: - SetupView
    private func setupView(){
        title = Localizable.kDetail.localized()
    }
    
    private func bindingData() {
        guard let viewModel = self.viewModel as? DetailViewModel else {
            return
        }
        deleteButton = UIBarButtonItem(title: Localizable.kDelete.localized(),style: .done, target: self,action: nil)

        let input = DetailViewModel.Input(tapDeleteTrigger: deleteButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        output.isShowDeleteButton.asObservable().subscribe(onNext: { [weak self] isShow in
            guard let self = self else { return }
            if isShow {
                self.navigationItem.rightBarButtonItem = self.deleteButton
            }else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }).disposed(by: disposeBag)
        
        output.tapDeleteButton.asObservable().subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigator.pop(sender: self)
            self.navigationItem.rightBarButtonItem = nil
        }).disposed(by: disposeBag)
        
        output.fullName.asObservable().bind(to: fullNameLabel.rx.text).disposed(by: disposeBag)
        output.descriptionField.asObservable().bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        output.starsCount.asObservable().bind(to: starsCountLabel.rx.text).disposed(by: disposeBag)
        output.forksCount.asObservable().bind(to: forksCountLabel.rx.text).disposed(by: disposeBag)
        output.language.asObservable().bind(to: languageLabel.rx.text).disposed(by: disposeBag)
    }
    
    //MARK: - Action
    @objc public func onClickDelete() {
        self.navigator.pop(sender: self)
        navigationItem.rightBarButtonItem = nil
    }
    
}
