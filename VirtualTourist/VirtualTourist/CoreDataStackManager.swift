//
//  CoreDataStack.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/1/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class CoreDataStackManager {
    lazy var managedObjectContext: NSManagedObjectContext! = {
        let modelURL = NSBundle.mainBundle().URLForResource("SwiftTestOne", withExtension: "momd")!
        let mom = NSManagedObjectModel(contentsOfURL: modelURL)!
        //ZAssert(mom != nil, "Error initializing mom from: \(modelURL)")
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let storeURL = (urls[urls.endIndex-1]).URLByAppendingPathComponent("VirtualTourist.sqlite")
        do {
        let store = try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch { return nil }
        //ZAssert(store != nil, "Unresolved error \(error?.localizedDescription), \(error?.userInfo)\nAttempted to create store at \(storeURL)")
        
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = psc
        
        return managedObjectContext
    }()
    
    func saveContext () throws {
        let moc = self.managedObjectContext
        
        if !moc.hasChanges {
            return
        }
        
        try moc.save()
    }
    
}