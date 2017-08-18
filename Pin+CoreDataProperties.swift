//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Jamel Reid  on 8/17/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var album: Album?

}
