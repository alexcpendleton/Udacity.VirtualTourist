//
//  PinPhoto.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/1/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import CoreData

@objc(PinPhoto)
class PinPhoto : NSManagedObject {
    struct Keys {
        static let id = "id"
        static let sourceUri = "sourceUri"
    }
    
    @NSManaged var id: NSNumber
    @NSManaged var sourceUri: String
    @NSManaged var pin: Pin
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("PinPhoto", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        id = dictionary[Keys.id] as! NSNumber
        sourceUri = dictionary[Keys.sourceUri] as! String
    }
}