//
//  LoadingView.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import FLAnimatedImage
import UIKit

public protocol LoadableView: AnyObject {
    var loadingView: LoadingView { get set }
}

public class LoadingView: UIView {
    @IBOutlet var imageViewContainer: UIView! {
        didSet {
            imageViewContainer.clipsToBounds = true
            imageViewContainer.layer.cornerRadius = 20
        }
    }

    @IBOutlet var imageView: FLAnimatedImageView! {
        didSet {
            let path = Bundle.main.url(forResource: "poptart_cat", withExtension: "gif")!
            let data = try! Data(contentsOf: path)
            self.imageView.animatedImage = FLAnimatedImage(gifData: data)
        }
    }

    override public var isHidden: Bool {
        didSet {
            superview?.bringSubviewToFront(self)
        }
    }
}

extension LoadableView where Self: UIViewController {
    func setupLoadingView() {
        loadingView.frame = view.bounds
        loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingView.isHidden = true
        view.addSubview(loadingView)
    }
}
