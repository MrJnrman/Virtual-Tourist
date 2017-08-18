//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Jamel Reid  on 8/17/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import Foundation
import CoreData

class Pin: NSManagedObject {
    
    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            self.init(entity: ent, insertInto: context)
            self.latitude = latitude
            self.longitude = longitude
        } else {
            fatalError("Unable to find entity name")
        }
    }
}
