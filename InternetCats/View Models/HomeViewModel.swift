//
//  HomeViewControllerViewModel.swift
//  InternetCats
//
//  Created by Derek Buchanan on 2/28/23.
//

import Foundation

class HomeViewModel {
    
    enum State {
        case idle
        case loading
        case finishedLoadingSuccessfully
        case errorFetchingTags(Error)
        case errorFetchingCats(Error)
        
        enum Case { case idle, loading }
        
        /// For use when you need to compare loading state:
        /// if viewModel.state.case != .loading { ... }
        var `case`: Case {
            switch self {
            case .loading: return .loading
            default: return .idle
            }
        }
    }
    
    private var catService: CatServiceType
    @Published private(set) var cats: [Cat] = []
    @Published private(set) var tags: [String] = []
    @Published private(set) var state: State = .idle
    private var limitCatsPerPage: Int = 10
    private var canLoadMore: Bool = true
    var selectedTag: String?
    
    init(catService: CatServiceType) {
        self.catService = catService
    }
    
    /// Load the available tags that we can sort cats by then load the first page of cats.
    func loadTagListThenFirstPage() {
        self.state = .loading
        
        self.catService.fetchTagList() { [weak self] (result) in
            
            switch result {
            case .success(let tags):
                self?.tags = tags
                self?.loadFirstPage()
            case .failure(let error):
                self?.state = .errorFetchingTags(error)
            }
        }
    }
    
    /// Load the first page results of cats. This will reset the cat dataset on success.
    func loadFirstPage() {
        self.state = .loading
        
        self.catService.fetchCatList(tag: self.selectedTag, limit: self.limitCatsPerPage, offset: 0) { [weak self] (result) in
            
            switch result {
            case .success(let cats):
                self?.cats = cats
                self?.canLoadMore = (cats.count == self?.limitCatsPerPage)
                self?.state = .finishedLoadingSuccessfully
            case .failure(let error):
                self?.state = .errorFetchingCats(error)
            }
        }
    }
    
    /// Load the next page results of cats
    func loadNextPage() {
        guard self.canLoadMore && self.state.case != .loading else { return }
        
        self.state = .loading
        
        self.catService.fetchCatList(tag: self.selectedTag, limit: self.limitCatsPerPage, offset: self.cats.count) { [weak self] (result) in
            
            switch result {
            case .success(let cats):
                self?.cats.append(contentsOf: cats)
                
                if let limitCatsPerPage = self?.limitCatsPerPage, cats.count < limitCatsPerPage {
                    self?.canLoadMore = false
                }
                
                self?.state = .finishedLoadingSuccessfully
            case .failure(let error):
                self?.canLoadMore = false
                self?.state = .errorFetchingCats(error)
            }
        }
    }
}
