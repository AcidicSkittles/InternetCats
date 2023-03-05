//
//  ImageLoadable.swift
//  InternetCats
//
//  Created by Derek Buchanan on 3/4/23.
//

import Foundation
import UIKit

protocol ImageLoadable: UIImageView {
    
    func loadImage(url: URL)
    
    func cancelImageLoading()
}
