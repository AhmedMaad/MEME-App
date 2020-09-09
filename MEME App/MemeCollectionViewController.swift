//
//  MemeCollectionViewController.swift
//  MEME App
//
//  Created by Ahmed Maad on 9/8/20.
//  Copyright © 2020 Next Trend. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionItem
        
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.topTextItem.text = meme.topString
        cell.imageItem?.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = memes[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
    }
    
}
