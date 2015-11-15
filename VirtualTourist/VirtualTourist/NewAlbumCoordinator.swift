//
//  NewAlbumCoordinator.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/9/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import PromiseKit
import CoreData
import UIKit
import MapKit

public class NewAlbumCoordinator {
    let context: NSManagedObjectContext
    let flickr: ExternalImageFetchable
    let organizer: PhotoOrganizer
    let placeholder: UIImage
    
    init(nsContext: NSManagedObjectContext, flickr f:ExternalImageFetchable, organizer o: PhotoOrganizer, placeholder ph:UIImage) {
        self.context = nsContext
        self.flickr = f
        self.organizer = o
        self.placeholder = ph
    }
    public var maxAlbumSize = 30
    
    public func make(forLocation: CLLocationCoordinate2D) throws -> Promise<Pin> {
        let pinRecord = Pin(lat: forLocation.latitude, lon: forLocation.longitude, context: context)
        var photosForPin = [PinPhoto]()
        // Save it without any photos for now
        try context.save()
        
        // Go get up to {maxAlbumSize} photos from Flickr
        return flickr.images(forLocation, atMost: maxAlbumSize).then { (body: [String]) -> Promise<Pin> in
            for item in body {
                // We don't want to download the image here, wait until
                // it gets displayed. However, we do want to know where
                // it will live.
                let fileName = self.organizer.makeUniquePng()
                
                // Now make the record and associate it with our Pin
                let ppRecord = PinPhoto(uri: item, fileName: fileName, context: self.context)
                ppRecord.pin = pinRecord
                photosForPin.append(ppRecord)
                
            }
            //pinRecord.photos = NSSet(array: photosForPin)
            try self.context.save()
            return Promise<Pin>(pinRecord)
        }
    }
    
    public func downloadAndStoreImage(from: String, to: String)->Promise<UIImage> {
        if from.isEmpty { return Promise<UIImage>(placeholder) }
        let imageRequest: NSURLRequest = NSURLRequest(URL: NSURL(string: from)!)
        return NSURLSession.sharedSession().promise(imageRequest).then({ (data:NSData) -> Promise<UIImage> in
            let image = UIImage(data: data)
            
            do {
                try self.organizer.save(image!, path: to, overwrite: false)
            } catch _ {
                // If for some reason we fail to save to the file system
                // it's not the end of the world, no point in blowing up.
                // We still have the image
            }
            return Promise<UIImage>(image!)
        })
    }
    
    public func makeAlbum(forLocation: CLLocationCoordinate2D) throws -> Promise<(PhotoAlbumModel, Pin)> {
        return try make(forLocation).then { (pin:Pin) -> Promise<(PhotoAlbumModel, Pin)> in
            var items = [PhotoAlbumMember]()
            for p in pin.photos {
                if let photo = p as? PinPhoto {
                    let fullPath = photo.fullPath(self.organizer)
                    let m = PhotoAlbumMember(placeholder: self.placeholder,
                        fetcher: self.downloadAndStoreImage(photo.sourceUri, to: fullPath))
                    items.append(m)
                }
            }
            let model = PhotoAlbumModel(coordinate: forLocation, members: Promise<[PhotoAlbumMember]>(items))
            return Promise<(PhotoAlbumModel, Pin)>(model, pin)
        }
    }
}
