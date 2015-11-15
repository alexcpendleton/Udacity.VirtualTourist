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
        static let sourceUri = "sourceUri"
        static let filePath = "filePath"
        static let pin = "pin"
    }
    
    @NSManaged var sourceUri: String
    @NSManaged var filePath: String
    @NSManaged var pin: Pin
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("PinPhoto", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        sourceUri = dictionary[Keys.sourceUri] as! String
        filePath = dictionary[Keys.filePath] as! String
    }
    convenience init(uri: String, path: String, context: NSManagedObjectContext) {
        self.init(dictionary:[
            Keys.sourceUri: uri,
            Keys.filePath: path,
        ], context: context)
    }
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}