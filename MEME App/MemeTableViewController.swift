//
//  MemeTableViewController.swift
//  MEME App
//
//  Created by Ahmed Maad on 9/8/20.
//  Copyright © 2020 Next Trend. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        print("No of Memes in table view \(memes.count)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topString
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = memes[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    
}
