//
//  NsmAppConfigurationFactory.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/3/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import CoreData

/** Handles the creation of AppConfiguration objects in the appropriate context. */
public class NsmAppConfigurationFactory {
    let context: NSManagedObjectContext
    init(context c: NSManagedObjectContext) {
        context = c
    }
    /**
     A convenience method to create an AppConfiguration instance without
     having to know all the dictionary keys or what context to put it in.
     - Parameter longitude: The last-used longitude.
     - Parameter latitude: The last-used latitude.
     - Parameter longitudeDelta: The last-used longitudeDelta (zoom level).
     - Parameter latitudeDelta: The last-used longitudeDelta (zoom level).
     */
    func create(longitude: NSNumber, latitude: NSNumber, longitudeDelta: NSNumber, latitudeDelta: NSNumber)->AppConfiguration {
        return create([
            AppConfiguration.Keys.latitude: latitude,
            AppConfiguration.Keys.longitude: longitude,
            AppConfiguration.Keys.latitudeDelta: latitudeDelta,
            AppConfiguration.Keys.longitudeDelta: longitudeDelta
            ])
    }
    /**
     Creates an AppConfiguration instance in the relevant context from a dictionary.
     Parameter dictionary: The dictionary to use to initialize the new instance.
     */
    func create(dictionary:[String:AnyObject]) -> AppConfiguration {
        return AppConfiguration(dictionary: dictionary, context: context)
    }
}