//
//  ImageMetadataFetcher.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/6/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import MapKit

public class ImageMetaDataFetcher {
    let placeholderMaker: PlaceholderImageFetcher
    
    public var albumDelay: Double = 2.0
    public var imageDelay: Double = 2.0
    
    init(maker:PlaceholderImageFetcher) {
        placeholderMaker = maker
    }
    
    func delayedImageFetcher() -> Promise<UIImage> {
        return Promise<UIImage> { fulfill, reject in
            imageDelay.delay {
                fulfill(self.afterLoad())
            }
        }
    }
    
    func afterLoad() -> UIImage {
        return placeholderMaker.onePlaceholder(UIColor.greenColor())
    }
    
    func beforeLoad() -> UIImage {
        return placeholderMaker.onePlaceholder(UIColor.redColor())
    }
    
    public func fetch(forLocation: CLLocationCoordinate2D) -> Promise<[PhotoAlbumMember]> {
        return Promise<[PhotoAlbumMember]> { fulfill, reject in
            albumDelay.delay {
                var result = [PhotoAlbumMember]()
                for _ in 1...25 {
                    let n = PhotoAlbumMember(placeholder:self.beforeLoad(), fetcher: self.delayedImageFetcher())
                    result.append(n)
                }
                fulfill(result)
            }
        }
    }
    /*

    public func fetch2(forLocation: CLLocationCoordinate2D) -> Promise<[PhotoAlbumMember]> {
        var photos = existingAlbum ? db.getPhotosMetaData(forLocation) : flickr.getPhotosMetaData(forLocation)
        for item in photos
        // Existing photos don't need a placeholder, but ones still to be fetched do
        item.placeholder = existingAlbum ? nil : makePlaceholder()
        item.image = nil // Gets filled by fetcher()
        item.fetcher = existingAlbum ? fetchFromFileSystem() : fetchFromFlickrAndSaveToFs()


    }    */
}

import CoreData

public class NewAlbumManager {
    let context: NSManagedObjectContext
    let flickr: ExternalImageFetchable
    let saver: PhotoSaver
    init(nsContext: NSManagedObjectContext, flickr f:ExternalImageFetchable, saver s: PhotoSaver) {
        self.context = nsContext
        self.flickr = f
        self.saver = s
    }
    public var maxAlbumSize = 30
    
    
    public func make(forLocation: CLLocationCoordinate2D) throws -> Promise<Pin> {
        let pinRecord = Pin(lat: forLocation.latitude, lon: forLocation.longitude, context: context)
        // Save it without any photos for now
        try context.save()
        
        // Go get up to {maxAlbumSize} photos from Flickr
        return flickr.images(forLocation).then { (body: [ImageRepresentable]) -> Promise<Pin> in
            for item in body {
                // We don't want to download the image here, wait until 
                // it gets displayed. However, we do want to know where
                // it will live.
                let path = self.saver.makeUniquePath()
                
                // Now make the record and associate it with our Pin
                let ppRecord = PinPhoto(uri: item.uri, path: path, parent: pinRecord, context: self.context)
                
                pinRecord.photos.append(ppRecord)
            }
            try self.context.save()
            return Promise<Pin>(pinRecord)
        }
    }
    /*
    public func makeAlbum(forLocation: CLLocationCoordinate2D) throws -> Promise<PhotoAlbumModel> {
        return try make(forLocation).then { (pin:Pin) -> AnyPromise in
//            var album = PhotoAlbumModel(coordinate: forLocation, members: <#T##Promise<[PhotoAlbumMember]>#>)
//            return Promise(pin)
        }
    }
*/
}

public class PhotoSaver {
    public func makeUniquePath()->String {
        return (documentsDirectory() + "/\(NSUUID().UUIDString).png")
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
}