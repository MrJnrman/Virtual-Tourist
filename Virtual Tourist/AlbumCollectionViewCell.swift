//
//  AlbumCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Jamel Reid  on 8/17/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var url: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.image = UIImage(named: "picture")
        
        
    }
}
