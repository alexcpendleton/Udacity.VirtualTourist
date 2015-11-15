//
//  Pin.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/1/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(Pin)
public class Pin : NSManagedObject {
    struct Keys {
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let photos = "photos"
    }
    
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var photos: NSSet
    
    public var coordinate: CLLocationCoordinate2D {
        get { return CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: self.longitude.doubleValue) }
    }
    
    convenience init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        latitude = dictionary[Keys.latitude] as! NSNumber
        longitude = dictionary[Keys.longitude] as! NSNumber
        //photos = dictionary[Keys.photos] as! NSSet
    }
    
    
    convenience init(lat:NSNumber, lon:NSNumber, context: NSManagedObjectContext) {
        self.init(dictionary: [
            Keys.latitude: lat,
            Keys.longitude: lon,
            Keys.photos: NSSet(array: [PinPhoto]())
        ], context: context)
    }
}