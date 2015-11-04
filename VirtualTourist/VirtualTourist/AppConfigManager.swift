//
//  AppConfigManager.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/3/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

/**
 Handles the single AppConfiguration record that is used for
 maintaining application state between loads.
 */
public class AppConfigManager {
    /** The single record whose properties you should change as needed.
     Call .save() to persist the changes. This is NSManaged, so any other
     context saving will also save this record.
     */
    public var record: AppConfiguration!
    let repo: NsmAppConfigurationRepository!
    
    /**
     Initializes a new instance of this class. This will immediately 
     call repo.only() to fill in this instance's record member.
     
     - Parameter repo:      The repository which handles the fetching and persistence
                            of the record.
     */
    init(repo r: NsmAppConfigurationRepository) {
        repo = r
        record = try! r.only()
    }
    
    /** Persists the current record's changes. */
    func save() {
        try! repo.save()
    }
}