//
//  CatEndpoint.swift
//  InternetCats
//
//  Created by Derek Buchanan on 2/28/23.
//

import Foundation

struct CatEndPoint: EndPointType {
    var baseURL: String = "https://cataas.com/api"
    var path: String
    var httpMethod: HTTPMethod
    var headers: [String: String]?
    var queryItems: [String: String]?
    var body: Codable?

    init(path: CatEndPointPath, httpMethod: HTTPMethod, headers: [String: String]? = nil, queryItems: [String: String]? = nil, body: Codable? = nil) {
        self.path = path.rawValue
        self.httpMethod = httpMethod
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }
}

enum CatEndPointPath: String {
    case cats = "/cats"
    case tags = "/tags"
}
