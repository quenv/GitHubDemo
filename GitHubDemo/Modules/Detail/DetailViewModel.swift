//
//  DetailViewModel.swift
//  GitHubDemo
//
//  Created by Macbook on 6/24/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import RxSwift
import RxCocoa

class DetailViewModel: ViewModel, ViewModelType {
  
    struct Input {
        let tapDeleteTrigger: Driver<Void>
    }
    
    struct Output {
        let isShowDeleteButton: BehaviorRelay<Bool>
        let fullName: Driver<String>
        let descriptionField: Driver<String>
        let starsCount: Driver<String>
        let forksCount: Driver<String>
        let language: Driver<String>
        let tapDeleteButton: Driver<Void>
    }

    private let disposeBag = DisposeBag()
    let repository: BehaviorRelay<Repository>

    init(repository: Repository) {
        self.repository = BehaviorRelay(value: repository)
        super.init()
    }

    func transform(input: Input) -> Output {
        let isShowDelete = BehaviorRelay<Bool>(value: false)
        isShowDelete.accept(hasShowDelete())
        
        let tapDeleteTrigger = input.tapDeleteTrigger
        tapDeleteTrigger.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.removeRepoFromFavorite()
        }).disposed(by: disposeBag)
        
        let fullName = repository.map { $0.fullname }.asDriverOnErrorJustComplete()
        let descriptionField = repository.map { $0.description  }.asDriverOnErrorJustComplete()
        let starsCount = repository.map { String($0.starsCount) }.asDriverOnErrorJustComplete()
        let forksCount = repository.map { String($0.forksCount) }.asDriverOnErrorJustComplete()
        let language = repository.map { $0.language }.asDriverOnErrorJustComplete()

        return Output(isShowDeleteButton: isShowDelete, fullName: fullName, descriptionField: descriptionField, starsCount: starsCount, forksCount: forksCount, language: language, tapDeleteButton: tapDeleteTrigger)
    }
    
    func hasShowDelete() -> Bool {
        let favoriteList = DBManager.shared().favoriteList
        let isExist = favoriteList.contains { (repo) -> Bool in
            repo.id == repository.value.id
        }
        return isExist
    }
    
    func removeRepoFromFavorite() {
        var favoriteList = DBManager.shared().favoriteList
        let firstIndex = favoriteList.firstIndex { (repo) -> Bool in
            repo.id ==  repository.value.id
        }
        if let index = firstIndex {
            favoriteList.remove(at: index)
            DBManager.shared().favoriteList = favoriteList
        }
    }
}


