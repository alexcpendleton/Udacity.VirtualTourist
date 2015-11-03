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
    init(context c: NSManagedObjectContext, factory: NsmAppConfigurationFactory, repository: NsmAppConfigurationRepository) {
        context = c
        appConfigFactory = factory
        repo = repository
    }
    public func fillIfNecessary() throws {
        if !determinedIfFilled() {
            try fill()
        }
    }
    
    func determinedIfFilled() -> Bool {
        do {
            let single = try repo.only()
            return single != nil
        } catch _ {
            return false
        }
            
    }
    
    func fill() throws {
        appConfigFactory.create(-122.0333687, latitude: 37.3318242, longitudeDelta: 6000, latitudeDelta: 6000)
        try context.save()
    }
}

public class NsmAppConfigurationRepository {
    var entityName = "AppConfiguration"
    
    let context: NSManagedObjectContext
    init(context c: NSManagedObjectContext) {
        context = c
    }
    
    public func only() throws -> AppConfiguration? {
        let request = NSFetchRequest(entityName: entityName)
        
        do {
            let results = try context.executeFetchRequest(request) as! [AppConfiguration]
            if results.count == 0 {
                return nil
            }
            return results.first!
        } catch {
            return nil
        }
        
    }
    
    public func save() throws {
        try context.save()
    }
}

public class NsmAppConfigurationFactory {
    let context: NSManagedObjectContext
    init(context c: NSManagedObjectContext) {
        context = c
    }
    func create(longitude: NSNumber, latitude: NSNumber, longitudeDelta: NSNumber, latitudeDelta: NSNumber)->AppConfiguration {
        return create([
            AppConfiguration.Keys.latitude: latitude,
            AppConfiguration.Keys.longitude: longitude,
            AppConfiguration.Keys.latitudeDelta: latitudeDelta,
            AppConfiguration.Keys.longitudeDelta: longitudeDelta
        ])
    }
    func create(dictionary:[String:AnyObject]) -> AppConfiguration {
        return AppConfiguration(dictionary: dictionary, context: context)
    }
}