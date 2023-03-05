//
//  DetailCatViewController.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import UIKit
import FLAnimatedImage
import Nuke

class DetailCatViewController: UIViewController {

    @IBOutlet weak var imageView: FLAnimatedImageView!
    @IBOutlet weak var tagLabel: UILabel!
    var viewModel: DetailCatViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
}

// MARK: - UI Methods
extension DetailCatViewController {
    func configureUI() {
        if let url = self.viewModel.cat.imageURL {
            self.imageView.loadImage(url: url)
        }
        
        self.navigationItem.title = self.viewModel.navigationTitle
        self.tagLabel.text = self.viewModel.tagLabelText
    }
}
