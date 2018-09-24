//
//  AddingImageFilterVC.swift
//  Hacker News
//
//  Created by Admin on 24/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import ImageProcessing
class AddingImageFilterVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    let processor = ImageProcessor()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image {
            imageView.image = image
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func done(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFilter(sender: UIBarButtonItem) {
        
        if let image = image {
            imageView.image = processor.processImage(image: image )
        }
        
    }

}
