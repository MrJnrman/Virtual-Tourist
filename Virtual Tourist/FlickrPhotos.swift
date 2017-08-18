//
//  FlickrPhotos.swift
//  Virtual Tourist
//
//  Created by Jamel Reid  on 8/18/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct FlickrPhotos {
    
    static var shared = FlickrPhotos()
    
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    lazy var context: NSManagedObjectContext = self.appDelegate.stack.context
    
    var title: String!
    var url: String!
    
    init() {
        
    }
    
    init(title: String, url: String) {
        self.title = title
        self.url = url
    }
    
    mutating func buildAndSave(_ results: AnyObject, pin: Pin, context: NSManagedObjectContext) {
        guard let photos = results["photos"] as? [String:AnyObject] else {
            return
        }
        
        guard let photo = photos["photo"] as? [[String:AnyObject]] else {
            return
        }
        
        // create album and link it to a pin
        let album = Album(name: "Album", context: context)
        album.pin = pin
        
        for pic in photo {
            
            guard let title = pic["title"] as? String else {
                continue
            }
            
            guard let url = pic["url_m"] as? String else {
                continue
            }
            
            // create photo and link it to a album
            let photo = Photo(title: title, url: url, context: context)
            photo.album = album
        }
        
    }
}
