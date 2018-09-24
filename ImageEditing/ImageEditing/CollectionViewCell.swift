//
//  CollectionViewCell.swift
//  Hacker News
//
//  Created by Admin on 24/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage? {
        willSet {
            imageView.image = newValue
        }
    }
}
