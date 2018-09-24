//
//  ViewController.swift
//  ImageEditing
//
//  Created by Admin on 24/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var filteringEffects = [ "CIPhotoEffectChrome",
                             "CIPhotoEffectFade",
                             "CIPhotoEffectInstant",
                             "CIPhotoEffectNoir",
                             "CIPhotoEffectProcess",
                             "CIPhotoEffectTonal",
                             "CIPhotoEffectTransfer",
                             "CISepiaTone","CIPhotoEffectMono"
    ]
    
    @IBOutlet weak var filtersScrollView: UIScrollView!
    @IBOutlet weak var imageToFilter: UIImageView!
    @IBOutlet weak var originalImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addingFiltersForImage()
    }
    
    @objc func handleButton(sender: UIButton) {
        let button = sender as UIButton
        imageToFilter.image = button.backgroundImage(for: .normal)
    }
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
       
        let alert = UIAlertController(title: "Filters", message: "Your image has been saved to Photo Library", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (Alert) in
            UIImageWriteToSavedPhotosAlbum(self.imageToFilter.image!, nil, nil, nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert .addAction(okAction)
        alert .addAction(cancelAction)
         self .present(alert, animated: true, completion: nil)
    }
    
    func addingFiltersForImage() {
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = filtersScrollView.frame.size.height
        let gapBetweenButtons: CGFloat = 5
        var itemCount = 0
        for i in 0..<filteringEffects.count {
            itemCount = i
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = itemCount
            filterButton.addTarget(self, action: #selector(self.handleButton(sender:)), for:.touchUpInside )
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image:originalImage.image!)
            let filter = CIFilter(name: "\(filteringEffects[i])" )
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let imageForButton = UIImage(cgImage: filteredImageRef!)
            filterButton.setBackgroundImage(imageForButton, for: .normal)
            xCoord +=  buttonWidth + gapBetweenButtons
            filtersScrollView.addSubview(filterButton)
            
        }
        filtersScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount+2), height: yCoord)
    }
    
}

