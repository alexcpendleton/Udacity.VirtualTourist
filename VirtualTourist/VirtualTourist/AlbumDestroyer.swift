//
//  AlbumDestroyer.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/16/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit

public class AlbumDestroyer {
    let context: NSManagedObjectContext
    let organizer: PhotoOrganizer
    init(context c: NSManagedObjectContext, organizer o: PhotoOrganizer) {
        self.context = c
        self.organizer = o
    }
    
    public func destroy(toDestroy: PhotoAlbumModel) throws {
        try destroy(toDestroy.pin)
    }
    public func destroy(pin: Pin) throws {
        // Delete all of the photos from the file system
        // This could be done asynchronously as not to lock 
        // up the main thread, even if it only takes a moment
        var paths = [String]()
        for item in pin.photos {
            if let photo = item as? PinPhoto {
                paths.append(organizer.path(photo.fileName))
            }
        }
        // If we do this asynchronously the record will probably be 
        // deleted/deleting while we're still going through the files
        // Hence, the copied list of paths
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            for path in paths {
                self.organizer.delete(path)
            }
        }
        // Deleting the Pin should cascade deletions of all the PinPhotos
        // Needs to happen on the main thread
        context.deleteObject(pin)
        try context.save()
    }
    public func destroyFile(forPhoto: PinPhoto) {
        organizer.delete(organizer.path(forPhoto.fileName))
    }
    
    public func destroy(photos: [PinPhoto]) throws {
        for i in photos {
            destroyFile(i)
            context.deleteObject(i)
        }
        try context.save()
    }
    
    public func destroy(photo: PinPhoto) throws {
        try destroy([photo])
    }
}