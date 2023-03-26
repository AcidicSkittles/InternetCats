//
//  DetailCatViewController.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import FLAnimatedImage
import Nuke
import UIKit

class DetailCatViewController: UIViewController {
    @IBOutlet var imageView: FLAnimatedImageView!
    @IBOutlet var tagLabel: UILabel!
    private var viewModel: DetailCatViewModel!

    init?(coder: NSCoder, viewModel: DetailCatViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
}

// MARK: - UI Methods

extension DetailCatViewController {
    func configureUI() {
        if let url = viewModel.cat.imageURL {
            imageView.loadImage(url: url)
        }

        navigationItem.title = viewModel.navigationTitle
        tagLabel.text = viewModel.tagLabelText
    }
}
