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
public class PinPhoto : NSManagedObject {
    struct Keys {
        static let sourceUri = "sourceUri"
        static let fileName = "fileName"
        static let pin = "pin"
    }
    
    @NSManaged var sourceUri: String
    @NSManaged var fileName: String
    @NSManaged var pin: Pin
    
    convenience init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("PinPhoto", inManagedObjectContext: context)
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        sourceUri = dictionary[Keys.sourceUri] as! String
        fileName = dictionary[Keys.fileName] as! String
    }
    convenience init(uri: String, fileName: String, context: NSManagedObjectContext) {
        self.init(dictionary:[
            Keys.sourceUri: uri,
            Keys.fileName: fileName,
        ], context: context)
    }
    
    internal func fullPath(using: PhotoOrganizer)->String {
        return using.path(self.fileName)
    }
}