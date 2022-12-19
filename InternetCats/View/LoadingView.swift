//
//  LoadingView.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import UIKit
import FLAnimatedImage

public protocol LoadableView: AnyObject {
    var loadingView: LoadingView { get set }
}

public class LoadingView: UIView {
    
    @IBOutlet weak var imageViewContainer: UIView! {
        didSet {
            self.imageViewContainer.clipsToBounds = true
            self.imageViewContainer.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var imageView: FLAnimatedImageView! {
        didSet {
            let path = Bundle.main.url(forResource: "poptart_cat", withExtension: "gif")!
            let data = try! Data(contentsOf: path)
            self.imageView.animatedImage = FLAnimatedImage.init(gifData: data)
        }
    }
    
    public override var isHidden: Bool {
        didSet {
            self.superview?.bringSubviewToFront(self)
        }
    }
}

extension LoadableView where Self: UIViewController {
    func setupLoadingView() {
        self.loadingView.frame = self.view.bounds
        self.loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.loadingView.isHidden = true
        self.view.addSubview(self.loadingView)
    }
}
