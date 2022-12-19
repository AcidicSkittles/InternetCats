//
//  CatService.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import UIKit

class CatService {
    static let shared: CatService = CatService()
    private let baseURL: String = "https://cataas.com"
    
    
    /// Retrieve a list of cats to display.
    /// - Parameters:
    ///   - tag: Filter cats by a specific tag
    ///   - limit: Max number of cats to return
    ///   - offset: Used for paging, number of cats to skip over
    ///   - completion: Completion block that returns a result list of cats on success or a result containing an error if there was one.
    func fetchCatList(tag: String? = nil, limit: Int, offset: Int, completion: @escaping (Result<[Cat], Error>) -> Void) {
        
        var queryParameters: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "skip", value: String(offset))
        ]
        
        if let tag {
            queryParameters.append(URLQueryItem(name: "tags", value: tag))
        }
        
        guard let validURL = self.apiURL(path: "/cats", parameters: queryParameters) else {
            return
        }
        
        URLSession.shared.dataTask(with: validURL) { (data, response, error) in
            DispatchQueue.main.async {
                guard let validData = data, error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                do {
                    let cats = try JSONDecoder().decode([Cat].self, from: validData)
                    completion(.success(cats))
                } catch let serializationError {
                    completion(.failure(serializationError))
                }
            }
        }.resume()
    }
    
    
    /// Fetch a list of possible tags you can filter cats by.
    /// - Parameter completion: Completion block returning a result of an array of string tags or a result error if there was one.
    func fetchTagList(completion: @escaping (Result<[String], Error>) -> Void) {
        
        guard let validURL = self.apiURL(path: "/tags") else {
            return
        }
        
        URLSession.shared.dataTask(with: validURL) { (data, response, error) in
            DispatchQueue.main.async {
                guard let validData = data, error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                do {
                    let tags = try JSONDecoder().decode([String].self, from: validData)
                    completion(.success(tags))
                } catch let serializationError {
                    completion(.failure(serializationError))
                }
            }
        }.resume()
    }
    
    private func apiURL(path: String, parameters: [URLQueryItem]? = nil) -> URL? {
        var baseURL = URL(string: self.baseURL)
        baseURL?.appendPathComponent("/api")
        baseURL?.appendPathComponent(path)
        
        if let parameters {
            baseURL?.append(queryItems: parameters)
        }
    
        return baseURL
    }
    
    
    /// Properly formatted image url for a cat.
    /// - Parameters:
    ///   - catId: The id of the desired cat
    ///   - width: Optional width if you would like the image width squeezed down (height aspect preserved). This is done on demand and is very slow.
    /// - Returns: A URL that points to an image of your input cat!
    func catImageURL(catId: String, width: CGFloat? = nil) -> URL? {
        var queryParameters: [URLQueryItem] = []
        if let width {
            queryParameters.append(URLQueryItem(name: "width", value: "\(Int(width))"))
        }
        
        var baseURL = URL(string: self.baseURL)
        baseURL?.appendPathComponent("/cat")
        baseURL?.appendPathComponent("/\(catId)")
        baseURL?.append(queryItems: queryParameters)
        
        return baseURL
    }
}
