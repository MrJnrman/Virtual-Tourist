//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Jamel Reid  on 8/17/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import Foundation
import CoreData

class Photo: NSManagedObject {
    convenience init(title: String, url: String, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.url = url
            self.title = title
        } else {
            fatalError("Unable to find entity name")
        }
    }
}
