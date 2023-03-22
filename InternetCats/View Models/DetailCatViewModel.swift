//
//  DetailCatViewControllerViewModel.swift
//  InternetCats
//
//  Created by Derek Buchanan on 2/28/23.
//

import Foundation

class DetailCatViewModel {
    private(set) var cat: Cat
    private(set) var navigationTitle: String = "Cat"
    private(set) var tagLabelText: String = ""

    init(cat: Cat) {
        self.cat = cat

        if let owner = self.cat.owner, owner != "null" {
            navigationTitle = "\(owner)'s Cat"
        }

        for tag in self.cat.tags {
            if tag == self.cat.tags.first {
                tagLabelText = "Tag list: \(tag)"
            } else {
                tagLabelText += ", \(tag)"
            }
        }
    }
}
