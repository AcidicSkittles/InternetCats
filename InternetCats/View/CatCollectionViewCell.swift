//
//  CatCollectionViewCell.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import UIKit
import FLAnimatedImage
import Nuke
import NukeFLAnimatedImagePlugin

class CatCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: FLAnimatedImageView!
    
    func setup(_ model: Cat) {
        if let url = model.imageURL {
            Nuke.loadImage(with: url, into: self.imageView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        Nuke.cancelRequest(for: self.imageView)
        self.imageView.animatedImage = nil
        self.imageView.image = nil
    }
}
