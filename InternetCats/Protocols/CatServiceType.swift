//
//  CatServiceType.swift
//  InternetCats
//
//  Created by Derek Buchanan on 2/28/23.
//

import Foundation

protocol CatServiceType: AnyObject {
    func fetchCatList(tag: String?, limit: Int, offset: Int, completion: @escaping (Result<[Cat], Error>) -> Void)
    func fetchTagList(completion: @escaping (Result<[String], Error>) -> Void)
}
