//
//  AppConfiguration.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/1/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import CoreData

@objc(AppConfiguration)
public class AppConfiguration : NSManagedObject {
    struct Keys {
        static let lastLogin = "lastLogin"
        static let zoomLevel = "zoomLevel"
        static let lastLongitude = "lastLongitude"
        static let lastLatitude = "lastLatitude"
    }
    
    @NSManaged var lastLogin: NSDate
    @NSManaged var zoomLevel: NSNumber
    @NSManaged var lastLongitude: NSNumber
    @NSManaged var lastLatitude: NSNumber
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("AppConfiguration", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        lastLogin = dictionary[Keys.lastLogin] as! NSDate
        zoomLevel = dictionary[Keys.zoomLevel] as! NSNumber
        lastLongitude = dictionary[Keys.lastLongitude] as! NSNumber
        lastLatitude = dictionary[Keys.lastLatitude] as! NSNumber
        
    }
}