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
    // cat to display details
    var cat: Cat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = self.cat.imageURL {
            Nuke.loadImage(with: url, into: self.imageView)
        }
        
        if let owner = self.cat.owner, owner != "null" {
            self.navigationItem.title = "\(owner)'s Cat"
        }
        
        var tagLabelText = ""
        for tag in self.cat.tags {
            if tag == self.cat.tags.first {
                tagLabelText = "Tag list: \(tag)"
            } else {
                tagLabelText = tagLabelText + ", \(tag)"
            }
        }
        
        self.tagLabel.text = tagLabelText
    }
}
