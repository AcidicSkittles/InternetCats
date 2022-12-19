//
//  Cat.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import Foundation

struct Cat: Codable {
    let id: String
    let tags: [String]
    let owner: String?
    var imageURL: URL? {
        get {
            return CatService.shared.catImageURL(catId: self.id)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case tags
        case owner
    }
}
