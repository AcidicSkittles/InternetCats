//
//  LayoutSettings.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import Foundation
import UIKit

struct LayoutSettings {
    static let spacing: CGFloat = 2

    static var itemsPerRow: Int {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 4
        } else {
            return 2
        }
    }
}
