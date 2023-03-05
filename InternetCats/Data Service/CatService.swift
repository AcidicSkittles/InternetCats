//
//  CatService.swift
//  InternetCats
//
//  Created by Derek Buchanan on 2/28/23.
//

import Foundation

class CatService: CatServiceType {
    
    private var network: NetworkServiceType
    private var imageBaseURL = "https://cataas.com/cat"
    
    init(network: NetworkServiceType) {
        self.network = network
    }
    
    /// Retrieve a list of cats to display.
    /// - Parameters:
    ///   - tag: Filter cats by a specific tag
    ///   - limit: Max number of cats to return
    ///   - offset: Used for paging, number of cats to skip over
    ///   - completion: Completion block that returns a result list of cats on success or a result containing an error if there was one.
    func fetchCatList(tag: String? = nil, limit: Int, offset: Int, completion: @escaping (Result<[Cat], Error>) -> Void) {
        
        var queryItems = ["limit" : String(limit),
                          "skip" : String(offset)]
        
        if let tag {
            queryItems["tags"] = tag
        }
        
        let endpoint = CatEndPoint(path: .cats, httpMethod: .get, queryItems: queryItems)
        
        self.network.call(endpoint: endpoint) { [weak self] (result: Result<[CatDTO], Error>) in
            switch result {
            case .success(let catDTOs):
                let cats: [Cat] = catDTOs.map {
                    let imageURL = self?.catImageURL(cat: $0)
                    let cat = Cat(id: $0.id, tags: $0.tags, owner: $0.owner, imageURL: imageURL)
                    return cat
                }
                
                completion(.success(cats))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetch a list of possible tags you can filter cats by.
    /// - Parameter completion: Completion block returning a result of an array of string tags or a result error if there was one.
    func fetchTagList(completion: @escaping (Result<[String], Error>) -> Void) {
        let endpoint = CatEndPoint(path: .tags, httpMethod: .get)
        
        self.network.call(endpoint: endpoint) { (result: Result<[String], Error>) in
            switch result {
            case .success(let tags):
                completion(.success(tags))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Properly formatted image url for a cat (not provided by API unfortunately).
    /// - Parameters:
    ///   - cat: The cat to generate an image URL for
    ///   - width: Optional width if you would like the image width squeezed down (height aspect preserved). This is done on demand and is very slow.
    /// - Returns: A URL that points to an image of your input cat!
    private func catImageURL(cat: CatDTO, width: CGFloat? = nil) -> URL? {
        var queryParameters: [URLQueryItem] = []
        if let width {
            queryParameters.append(URLQueryItem(name: "width", value: "\(Int(width))"))
        }
        
        var baseURL = URL(string: self.imageBaseURL)
        baseURL?.appendPathComponent("/\(cat.id)")
        baseURL?.append(queryItems: queryParameters)
        
        return baseURL
    }
}
