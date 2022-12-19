//
//  CatDataRepository.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import UIKit

class CatDataRepository: NSObject {
    private(set) var cats: [Cat] = []
    private(set) var isLoadingImages: Bool = false
    private(set) var isLoadingTags: Bool = false
    private(set) var tags: [String] = []
    private var limitCatsPerPage: Int = 10
    private var canLoadMore: Bool = true
    var tag: String?
    
    /// Load the available tags that we can sort cats by.
    /// - Parameter completion: Completion block that returns an error if one was encountered.
    func loadTagList(completion: @escaping ((Error?) -> Void)) {
        self.isLoadingTags = true
        CatService.shared.fetchTagList() { (result) in
            self.isLoadingTags = false
            
            switch result {
                case .success(let cats):
                    self.tags = cats
                    completion(nil)
                case .failure(let error):
                    completion(error)
            }
        }
    }
    
    
    /// Load the first page results of cats. This will reset the cat dataset on success.
    /// - Parameter completion: Completion block that returns an error if one was encountered.
    func loadFirstPage(completion: @escaping ((Error?) -> Void)) {
        
        self.isLoadingImages = true
        CatService.shared.fetchCatList(tag: self.tag, limit: self.limitCatsPerPage, offset: 0) { (result) in
            self.isLoadingImages = false
            
            switch result {
                case .success(let cats):
                    self.cats = cats
                    self.canLoadMore = (cats.count == self.limitCatsPerPage)
                    completion(nil)
                case .failure(let error):
                    completion(error)
            }
        }
    }
    
    
    /// Load the next page results of cats
    /// - Parameter completion: Completion block that returns an error if one was encountered.
    func loadNextPage(completion: @escaping ((Error?) -> Void)) {
        guard self.canLoadMore else { return }
        
        self.isLoadingImages = true
        CatService.shared.fetchCatList(tag: self.tag, limit: self.limitCatsPerPage, offset: self.cats.count) { (result) in
            self.isLoadingImages = false
            
            switch result {
                case .success(let cats):
                    self.cats.append(contentsOf: cats)
                
                    if cats.count < self.limitCatsPerPage {
                        self.canLoadMore = false
                    }
                    
                    completion(nil)
                case .failure(let error):
                    self.canLoadMore = false
                    completion(error)
            }
        }
    }
}
