//
//  Meme.swift
//  MEME App
//
//  Created by Ahmed Maad on 9/8/20.
//  Copyright © 2020 Next Trend. All rights reserved.
//

import Foundation
import UIKit

public struct Meme{
    let topString: String
    let bottomString: String
    let image: UIImageView
    let memedImage: UIImage
    
    init(topString: String, bottomString: String, image: UIImageView, memedImage: UIImage) {
        self.topString = topString
        self.bottomString = bottomString
        self.image = image
        self.memedImage = memedImage
    }
}
