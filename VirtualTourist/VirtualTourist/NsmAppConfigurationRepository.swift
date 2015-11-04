//
//  NsmAppConfigurationRepository.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/3/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import CoreData

/** Manages the database operations for AppConfiguration objects. */
public class NsmAppConfigurationRepository {
    /** The entity name as used in CoreData. */
    var entityName = "AppConfiguration"
    
    let context: NSManagedObjectContext
    /**
     - Parameter context: The CoreData context to use.
     */
    init(context c: NSManagedObjectContext) {
        context = c
    }
    /** There should really only be one record in this table, so this method
     grabs the first row or nil.
     - Throws: Has the potential to bubble exceptions from Core Data calls,
     but doesn't throw any of its own.
     */
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
    
    /** Saves the current Core Data context.
     - Throws: Has the potential to bubble exceptions from Core Data calls,
     but doesn't throw any of its own.
     */
    public func save() throws {
        try context.save()
    }
}
