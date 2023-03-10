//
//  UIView+extensions.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
