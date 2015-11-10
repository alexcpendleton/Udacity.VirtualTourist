//
//  Pin.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/1/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import CoreData

@objc(Pin)
public class Pin : NSManagedObject {
    struct Keys {
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let id = "id"
        //static let photos = "photos"
    }
    
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var id: NSNumber
    @NSManaged var photos: [PinPhoto]
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        latitude = dictionary[Keys.latitude] as! NSNumber
        longitude = dictionary[Keys.longitude] as! NSNumber
        id = dictionary[Keys.id] as! NSNumber
    }
    
    convenience init(lat:NSNumber, lon:NSNumber, context: NSManagedObjectContext) {
        self.init(dictionary: [
            Keys.latitude: lat,
            Keys.longitude: lon
        ], context: context)
    }
}