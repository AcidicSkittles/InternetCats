//
//  CatDTO.swift
//  InternetCats
//
//  Created by Derek Buchanan on 2/28/23.
//

import Foundation


/// Data Transfer Object that represents API response.
struct CatDTO: Codable {
    let id: String
    let tags: [String]
    let owner: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case tags
        case owner
    }
}
