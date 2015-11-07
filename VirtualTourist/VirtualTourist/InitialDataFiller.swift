//
//  InitialDataFiller.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/1/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import CoreData

/** Handles the initial filling of data for the first load of the app. */
public class InitialDataFiller {
    let appConfigFactory: NsmAppConfigurationFactory
    let repo: NsmAppConfigurationRepository
    let context: NSManagedObjectContext
    init(context c: NSManagedObjectContext, factory: NsmAppConfigurationFactory, repository: NsmAppConfigurationRepository) {
        context = c
        appConfigFactory = factory
        repo = repository
    }
    
    /** Adds the appropriate initial data if there's nothing there already. */
    public func fillIfNecessary() throws {
        if !determinedIfFilled() {
            try fill()
        }
    }
    /** Determines if there's already a record in the database. */
    func determinedIfFilled() -> Bool {
        do {
            let single = try repo.only()
            return single != nil
        } catch _ {
            return false
        }
            
    }
    /** 
     Creates and stores a single AppConfiguration record using the default values. 
     Throws: Bubbles up exceptions from Core Data calls.
     */
    func fill() throws {
        appConfigFactory.create(-122.0333687, latitude: 37.3318242, longitudeDelta: 8.802282992708086, latitudeDelta: 11.37994597593392)
        try context.save()
    }
}