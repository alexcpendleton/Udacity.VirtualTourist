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
class Pin : NSManagedObject {
    struct Keys {
        static let name = "name"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let id = "id"
        //static let photos = "photos"
    }
    
    @NSManaged var name: String
    @NSManaged var latitude: Float
    @NSManaged var longitude: Float
    @NSManaged var id: NSNumber
    @NSManaged var photos: [PinPhoto]
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        name = dictionary[Keys.name] as! String
        latitude = dictionary[Keys.latitude] as! Float
        longitude = dictionary[Keys.longitude] as! Float
        id = dictionary[Keys.id] as! NSNumber
    }
}