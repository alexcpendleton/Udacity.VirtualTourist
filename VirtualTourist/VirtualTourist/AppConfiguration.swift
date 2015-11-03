//
//  AppConfiguration.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/1/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(AppConfiguration)
public class AppConfiguration : NSManagedObject {
    struct Keys {
        static let longitude = "longitude"
        static let latitude = "latitude"
        static let longitudeDelta = "longitudeDelta"
        static let latitudeDelta = "latitudeDelta"
    }
    
    
    @NSManaged var latitudeDelta: NSNumber
    @NSManaged var longitudeDelta: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    
    public var coordinate : CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
        }
    }
    
    convenience init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("AppConfiguration", inManagedObjectContext: context)
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        longitude = dictionary[Keys.longitude] as! NSNumber
        latitude = dictionary[Keys.latitude] as! NSNumber
        longitudeDelta = dictionary[Keys.longitudeDelta] as! NSNumber
        latitudeDelta = dictionary[Keys.latitudeDelta] as! NSNumber
    }
}