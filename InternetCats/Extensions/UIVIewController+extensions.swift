//
//  UIVIewController+extensions.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import Foundation
import UIKit

extension UIViewController {
    func show(alert: String) {
        let alert = UIAlertController(title: "", message: alert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
