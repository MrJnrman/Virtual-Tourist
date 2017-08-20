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
    
    mutating func parse(_ results: AnyObject, pin: Pin, context: NSManagedObjectContext) {
        
        // TODO: randomize images based on page and page count
        guard let photos = results["photos"] as? [String:AnyObject] else {
            return
        }
        
        guard let photo = photos["photo"] as? [[String:AnyObject]] else {
            return
        }
        
        if photo.count > 20 {
            extractAndSave(photo, limit: 19, pin: pin, context: context)
        } else {
            extractAndSave(photo, limit: photo.count, pin: pin, context: context)
        }
        
    }
    
    
    func extractAndSave(_ photos: [[String:AnyObject]], limit: Int, pin: Pin, context: NSManagedObjectContext) {
        var albumName = "Album"
        
        if pin.album != nil {
            albumName = (pin.album?.name)!
            context.delete(pin.album!)
        }
        
        // create album and link it to a pin
        let album = Album(name: albumName, context: context)
        album.pin = pin
        
        for index in 0..<limit {
            guard let title = photos[index]["title"] as? String else {
                continue
            }
            print("Title: \(title)")
            
            guard let url = photos[index]["url_m"] as? String else {
                continue
            }

            // create photo and link it to a album
            let photo = Photo(title: title, url: url, context: context)
            photo.album = album
        }
    }
}
