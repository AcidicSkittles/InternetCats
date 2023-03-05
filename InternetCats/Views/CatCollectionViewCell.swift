//
//  CatCollectionViewCell.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import UIKit
import FLAnimatedImage

class CatCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: FLAnimatedImageView!
    var viewModel: CatCollectionViewModel!
    
    func configure(withViewModel viewModel: CatCollectionViewModel) {
        self.viewModel = viewModel
        
        if let url = viewModel.cat.imageURL {
            self.imageView.loadImage(url: url)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.cancelImageLoading()
        self.imageView.animatedImage = nil
        self.imageView.image = nil
    }
}
