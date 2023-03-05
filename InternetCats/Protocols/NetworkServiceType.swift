//
//  NetworkServiceType.swift
//  InternetCats
//
//  Created by Derek Buchanan on 2/28/23.
//

import Foundation

protocol NetworkServiceType: AnyObject {
    func call<T:Codable>(endpoint: EndPointType, completion: @escaping (Result<T, Error>) -> Void)
}

protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String : String]? { get }
    var queryItems: [String : String]? { get }
    var body: Codable? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
