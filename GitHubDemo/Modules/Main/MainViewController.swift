//
//  MainViewController.swift
//  GitHubDemo
//
//  Created by Macbook on 6/22/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var normalTableView: UITableView!
    @IBOutlet weak var searchingTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var isSearching = BehaviorRelay<Bool>(value: false)
    var popularButton: UIBarButtonItem!
    var recentButton: UIBarButtonItem!
    var logoutButton: UIBarButtonItem!

    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.normalTableView.deselectSelectedRow()
        self.searchingTableView.deselectSelectedRow()
    }
    
    //MARK: - SetupView
    private func setupTableView(){
        normalTableView.registerNib(NormalCell.className)
        searchingTableView.registerNib(SearchingCell.className)
        normalTableView.keyboardDismissMode = .onDrag
        searchingTableView.keyboardDismissMode = .onDrag
    }
    
    func showDetailView(_ model: Repository){
        self.view.endEditing(true)
        self.navigator.show(segue: .detail(model: model), sender: self, transition: .push)
    }

}

//MARK: - Binding Data
extension MainViewController {
    
    private func bindingData() {
        guard let viewModel = viewModel as? MainViewModel else { return }

        popularButton = UIBarButtonItem(title: Localizable.kPopular.localized(),style: .done,target: self,action: nil)
        recentButton = UIBarButtonItem(title: Localizable.kRecent.localized(),style: .done, target: self,action: nil)
        logoutButton = UIBarButtonItem(title: Localizable.kLogout.localized(),style: .done,target: self,action: nil)
        
        let input = MainViewModel.Input(viewWillAppear: self.rx.viewWillAppear.asDriverOnErrorJustComplete(),
                                        keywordTrigger: searchTextField.rx.text.orEmpty.throttle(.milliseconds(300), scheduler: MainScheduler.instance).asDriverOnErrorJustComplete(),
                                        textDidBeginEditing: searchTextField.rx.controlEvent([.editingDidBegin]).asDriver(),
                                        tapCancelButton: cancelButton.rx.tap.asDriver(),
                                        tapPopularButton: popularButton.rx.tap.asDriver(),
                                        tapRecentButton: recentButton.rx.tap.asDriver(),
                                        tapLogoutButton: logoutButton.rx.tap.asDriver(),
                                        normalSelection: normalTableView.rx.modelSelected(Repository.self).asDriver(),
                                        searchingSelection: searchingTableView.rx.modelSelected(Repository.self).asDriver() )
        
        let output = viewModel.transform(input: input)
        
        output.normalResult.asObservable()
            .bind(to: normalTableView.rx.items(cellIdentifier: NormalCell.className, cellType: NormalCell.self)){ (tableView, repo, cell) in
                cell.model = repo
            }.disposed(by: disposeBag)
        
        output.searchResult.asObservable()
            .bind(to: searchingTableView.rx.items(cellIdentifier: SearchingCell.className, cellType: SearchingCell.self)){(tableView, repo, cell) in
                cell.onCheckClick = {
                    repo.isMarked ? viewModel.removeFromFavorite(repo) : viewModel.addToFavorite(repo)
                    cell.model = repo
                }
                cell.model = repo
            }.disposed(by: disposeBag)
        
        output.tapCancelButton.asObservable().subscribe(onNext: { [weak self] in
            self?.dismissKeyboard()
        }).disposed(by: disposeBag)
        
        output.tapLogoutButton.asObservable().subscribe(onNext: {  [weak self] in
            guard let self = self else { return }
            self.navigator.show(segue: .login, sender: self, transition: .root(in: self.appDelegate.window!))
        }).disposed(by: disposeBag)
        
        output.searchingSelected.drive(onNext: { [weak self] (viewModel) in
            guard let self = self else { return }
            self.showDetailView(viewModel.repository.value)
        }).disposed(by: disposeBag)
        
        output.normalSelected.drive(onNext: { [weak self] (viewModel) in
            guard let self = self else { return }
            self.showDetailView(viewModel.repository.value)
        }).disposed(by: disposeBag)
        
        output.modeView.asObservable().subscribe(onNext: {[weak self] mode in
            guard let self = self else { return }
            if mode == .normal {
                self.searchTextField.text = ""
                self.title = Localizable.kNormal.localized()
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.rightBarButtonItem = self.logoutButton
                self.cancelButton.isHidden = true
                self.normalTableView.isHidden = false
                self.searchingTableView.isHidden = true
            }else {
                self.title = Localizable.kSearching.localized()
                self.navigationItem.leftBarButtonItem = self.popularButton
                self.navigationItem.rightBarButtonItem = self.recentButton
                self.cancelButton.isHidden = false
                self.normalTableView.isHidden = true
                self.searchingTableView.isHidden = false
            }
        }).disposed(by: disposeBag)
        
      
    }
}
