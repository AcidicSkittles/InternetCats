//
//  FLAnimatedImage+extensions.swift
//  InternetCats
//
//  Created by Derek Buchanan on 3/4/23.
//

import UIKit
import FLAnimatedImage
import Nuke

extension FLAnimatedImageView: ImageLoadable {
    func loadImage(url: URL) {
        Nuke.loadImage(with: url, into: self)
    }
    
    func cancelImageLoading() {
        Nuke.cancelRequest(for: self)
    }
}
