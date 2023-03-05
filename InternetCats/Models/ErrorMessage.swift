//
//  ErrorMessage.swift
//  InternetCats
//
//  Created by Derek Buchanan on 2/28/23.
//

import Foundation

struct ErrorMessage: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
