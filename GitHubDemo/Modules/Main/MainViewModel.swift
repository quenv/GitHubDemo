//
//  MainViewModel.swift
//  GitHubDemo
//
//  Created by Macbook on 6/23/19.
//  Copyright © 2019 QueNguyen. All rights reserved.
//

import RxSwift
import RxCocoa

enum MainViewMode {
    case normal
    case searching
}

class MainViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let viewWillAppear: Driver<Bool>
        let keywordTrigger: Driver<String>
        let textDidBeginEditing: Driver<Void>
        let tapCancelButton: Driver<Void>
        let tapPopularButton: Driver<Void>
        let tapRecentButton: Driver<Void>
        let tapLogoutButton: Driver<Void>
        let normalSelection: Driver<Repository>
        let searchingSelection: Driver<Repository>
    }
    
    struct Output {
        let isSearching: BehaviorRelay<Bool>
        let searchResult: BehaviorRelay<[Repository]>
        let normalResult: BehaviorRelay<[Repository]>
        let textDidBeginEditing: Driver<Void>
        let tapCancelButton: Driver<Void>
        let searchingSelected: Driver<DetailViewModel>
        let normalSelected: Driver<DetailViewModel>
        let tapLogoutButton: Driver<Void>
        let modeView: BehaviorRelay<MainViewMode>
    }
    
    private let disposeBag = DisposeBag()
    let mode: BehaviorRelay<MainViewMode>
    let searchResult = BehaviorRelay<[Repository]>(value: [])
    let normalResult = BehaviorRelay<[Repository]>(value: [])

    init(mode: MainViewMode) {
        self.mode = BehaviorRelay(value: mode)
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let isSearching = BehaviorRelay<Bool>(value: false)
        let textDidBeginEditing = input.textDidBeginEditing
        let keywordTrigger = input.keywordTrigger
        let tapCancelButton = input.tapCancelButton
        let tapPopularButton = input.tapPopularButton
        let tapRecentButton = input.tapRecentButton
        let tapLogoutButton = input.tapLogoutButton
        let viewWillAppear = input.viewWillAppear
        
        let searchingDetails = input.searchingSelection.map({ (model) -> DetailViewModel in
            let viewModel = DetailViewModel(repository: model)
            return viewModel
        })
        
        let normalDetails = input.normalSelection.map({ (model) -> DetailViewModel in
            let viewModel = DetailViewModel(repository: model)
            return viewModel
        })
        
        keywordTrigger.drive(onNext: { [weak self] keyword in
            guard let self = self else { return }
            self.searchRepositories(keyword: keyword)
        }).disposed(by: disposeBag)
        
        textDidBeginEditing.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.mode.accept(.searching)
        }).disposed(by: disposeBag)
        
        tapCancelButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.mode.accept(.normal)
        }).disposed(by: disposeBag)
        
        mode.subscribe(onNext: {[weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .normal:
                isSearching.accept(false)
                let favoriteList = DBManager.shared().favoriteList
                self.normalResult.accept(favoriteList)
                self.searchResult.accept([])
            case .searching:
                isSearching.accept(true)
                self.updateSearchResult(self.searchResult.value)
            }
        }).disposed(by: disposeBag)
        
        //sort by star
        tapPopularButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            let oldRepos = self.searchResult.value
            let newRepos = oldRepos.sorted(by: { $0.starsCount > $1.starsCount })
            self.searchResult.accept(newRepos)
        }).disposed(by: disposeBag)
        
        //sort by time
        tapRecentButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            let oldRepos = self.searchResult.value
            let newRepos = oldRepos.sorted(by: { $0.updatedTime > $1.updatedTime })
            self.searchResult.accept(newRepos)
        }).disposed(by: disposeBag)
        
        //logout
        tapLogoutButton.drive(onNext: { _ in
            User.removeCurrentUser()
            DBManager.shared().favoriteList = []
        }).disposed(by: disposeBag)
        
        viewWillAppear.drive(onNext: { [weak self] isShow in
            guard let self = self else { return }
            if isShow {
                self.updateSearchResult(self.searchResult.value)
                let favoriteList = DBManager.shared().favoriteList
                self.normalResult.accept(favoriteList)
            }
        }).disposed(by: disposeBag)
        
        return Output(isSearching: isSearching, searchResult: searchResult, normalResult: normalResult, textDidBeginEditing: textDidBeginEditing, tapCancelButton: tapCancelButton, searchingSelected: searchingDetails, normalSelected: normalDetails, tapLogoutButton: tapLogoutButton, modeView: mode)
    }
    
    //MARK: - Add & Remove Favorite
    func addToFavorite(_ repo: Repository) {
        var favoriteList = DBManager.shared().favoriteList
        let isExist = favoriteList.contains { (favorite) -> Bool in
            favorite.id == repo.id
        }
        repo.isMarked = true
        if !isExist {
            favoriteList.insert(repo, at: 0)
            DBManager.shared().favoriteList = favoriteList
        }
    }
    
    func removeFromFavorite(_ repo: Repository) {
        var favoriteList = DBManager.shared().favoriteList
        let firstIndex = favoriteList.firstIndex { (favorite) -> Bool in
            favorite.id == repo.id
        }
        repo.isMarked = false
        if let index = firstIndex {
            favoriteList.remove(at: index)
            DBManager.shared().favoriteList = favoriteList
        }
    }
    
    // MARK: - Search repositories
    func searchRepositories(keyword: String) {
        if keyword.isEmpty {
            self.searchResult.accept([])
            return
        }
        if hasKeywordFromCache(keyword) {
            let repos = getRepositoryFromCache(keyword)
            self.searchResult.accept(repos)
            return
        }
        self.provider.searchRepositories(query: keyword)
            .subscribe(onNext: { [weak self] (result, status) in
                guard let self = self else { return }
                if status == .invalidData || status == .error {
                    self.searchResult.accept([])
                    return
                }
                if status == .success, let repos = result {
                    self.updateSearchResult(repos)
                    self.updateRecentSearch(keyword: keyword, repos: repos)
                    return
                }
            }).disposed(by: disposeBag)
        
    }
    
    private func updateSearchResult(_ repos: [Repository]){
        var newRepos: [Repository] = []
        let favoriteList = DBManager.shared().favoriteList
        for repo in repos {
            let isSame = favoriteList.contains { (favoriteRepo) -> Bool in
                favoriteRepo.id == repo.id
            }
            repo.isMarked = isSame
            newRepos.append(repo)
        }
        self.searchResult.accept(newRepos)
    }
    
    
    // MARK: - Local Data
    func updateRecentSearch(keyword: String, repos: [Repository]) {
        var currentDict = DBManager.shared().recentDict
        let favoriteList = DBManager.shared().favoriteList
        var dicts: [[String: Any]] = []
        for repo in repos {
            let isSame = favoriteList.contains { (favoriteRepo) -> Bool in
                favoriteRepo.id == repo.id
            }
            repo.isMarked = isSame
            let dict = repo.getDictionary()
            dicts.append(dict)
        }
        currentDict[keyword] = dicts
        DBManager.shared().recentDict = currentDict
    }
 
    
    func hasKeywordFromCache(_ keyword: String) -> Bool {
        return DBManager.shared().recentDict[keyword] != nil
    }
    
    func getRepositoryFromCache(_ keyword: String) -> [Repository] {
        var repos: [Repository] = []
        let recentDict = DBManager.shared().recentDict
        let favoriteList = DBManager.shared().favoriteList
        guard let dicts = recentDict[keyword] as? [[String: Any]]
            else { return repos }
        for dict in dicts {
            if let repo = Repository(JSON: dict) {
                let isSame = favoriteList.contains { (favoriteRepo) -> Bool in
                    favoriteRepo.id == repo.id
                }
                repo.isMarked = isSame
                repos.append(repo)
            }
        }
        return repos
    }
    
}


