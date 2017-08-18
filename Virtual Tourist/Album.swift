//
//  Album.swift
//  Virtual Tourist
//
//  Created by Jamel Reid  on 8/17/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import Foundation
import CoreData

class Album: NSManagedObject {
    convenience init(name: String, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Album", in: context) {
            self.init(entity: ent, insertInto: context)
            self.name = name
        } else {
            fatalError("Unable to find entity name")
        }
    }
}
