//
//  FLAnimatedImage+extensions.swift
//  InternetCats
//
//  Created by Derek Buchanan on 3/4/23.
//

import FLAnimatedImage
import Nuke
import UIKit

extension FLAnimatedImageView: ImageLoadable {
    func loadImage(url: URL) {
        Nuke.loadImage(with: url, into: self)
    }

    func cancelImageLoading() {
        Nuke.cancelRequest(for: self)
    }
}
