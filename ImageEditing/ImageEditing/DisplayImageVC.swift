//
//  DisplayImageVC.swift
//  Hacker News
//
//  Created by Admin on 24/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class DisplayImageVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
   
    
    @IBOutlet var imagesCollectionView: UICollectionView!
    
    var images: [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
     images = ["wikimedia_faces_01", "wikimedia_faces_02", "wikipedia_dog", "IT_crowd_02", "right_hook", "solar_car", "guess_what", "dog_in_suit"]
      
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath as IndexPath) as! CollectionViewCell
        cell.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let index = collectionView.indexPathsForSelectedItems
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddingImageFilterVC") as! AddingImageFilterVC
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        newViewController.image = cell.image
        self.present(newViewController, animated: false, completion: nil)
    
    }
    
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowImage") {
            let imageViewController = segue.destination as! AddingImageFilterVC
            let cell = sender as! CollectionViewCell
            imageViewController.image = cell.image
        }
    }
}
