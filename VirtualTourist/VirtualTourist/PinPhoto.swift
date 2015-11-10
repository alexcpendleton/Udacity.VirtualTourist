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
        static let filePath = "filePath"
        static let pin = "pin"
    }
    
    @NSManaged var id: NSNumber
    @NSManaged var sourceUri: String
    @NSManaged var filePath: String
    @NSManaged var pin: Pin
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("PinPhoto", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        id = dictionary[Keys.id] as! NSNumber
        sourceUri = dictionary[Keys.sourceUri] as! String
        filePath = dictionary[Keys.filePath] as! String
        pin = dictionary[Keys.pin] as! Pin
    }
    convenience init(uri: String, path: String, parent:Pin, context: NSManagedObjectContext) {
        self.init(dictionary:[
            Keys.sourceUri: uri,
            Keys.filePath: path,
            Keys.pin: parent
        ], context: context)
    }
}