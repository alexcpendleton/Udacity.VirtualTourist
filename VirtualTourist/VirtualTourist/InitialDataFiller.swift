//
//  InitialDataFiller.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/1/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import CoreData

public class InitialDataFiller {
    let appConfigFactory: NsmAppConfigurationFactory
    let repo: NsmAppConfigurationRepository
    let context: NSManagedObjectContext
    init(context c: NSManagedObjectContext) {
        context = c
        appConfigFactory = NsmAppConfigurationFactory(context: c)
        repo = NsmAppConfigurationRepository(context: c)
    }
    public func fillIfNecessary() throws {
        if !determinedIfFilled() {
            try fill()
        }
    }
    
    func determinedIfFilled() -> Bool {
        return repo.all().count > 0
    }
    
    func fill() throws {
        appConfigFactory.create(NSDate(), zoomLevel: 1.0, longitude: 37.3318242, latitude: -122.0333687)
        try context.save()
    }
}

public class NsmAppConfigurationRepository {
    var entityName = "AppConfiguration"
    
    let context: NSManagedObjectContext
    init(context c: NSManagedObjectContext) {
        context = c
    }
    
    public func all() -> [AppConfiguration] {
        let request = NSFetchRequest(entityName: entityName)
        
        do {
            let results = try context.executeFetchRequest(request) as! [AppConfiguration]
            return results
        } catch {
            print("Error fetching all AppConfiguration")
            return [AppConfiguration]()
        }
    }
}

public class NsmAppConfigurationFactory {
    let context: NSManagedObjectContext
    init(context c: NSManagedObjectContext) {
        context = c
    }
    func create(lastLogin: NSDate, zoomLevel: Double, longitude: Float, latitude: Float)->AppConfiguration {
        return create([
            AppConfiguration.Keys.lastLatitude: NSNumber(float: latitude),
            AppConfiguration.Keys.lastLogin: lastLogin,
            AppConfiguration.Keys.lastLongitude: NSNumber(float: longitude),
            AppConfiguration.Keys.zoomLevel: NSNumber(double: zoomLevel)
        ])
    }
    func create(dictionary:[String:AnyObject]) -> AppConfiguration {
        return AppConfiguration(dictionary: dictionary, context: context)
    }
}