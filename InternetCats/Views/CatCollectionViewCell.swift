//
//  CatCollectionViewCell.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import FLAnimatedImage
import UIKit

class CatCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: FLAnimatedImageView!
    var viewModel: CatCollectionViewModel!

    func configure(withViewModel viewModel: CatCollectionViewModel) {
        self.viewModel = viewModel

        if let url = viewModel.cat.imageURL {
            imageView.loadImage(url: url)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.cancelImageLoading()
        imageView.animatedImage = nil
        imageView.image = nil
    }
}
