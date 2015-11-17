//
//  ExistingAlbumCoordinator.swift
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

public class ExistingAlbumCoordinator {
    let context: NSManagedObjectContext
    let placeholder: UIImage
    let organizer: PhotoOrganizer
    
    init(nsContext: NSManagedObjectContext, placeholder ph:UIImage, organizer o: PhotoOrganizer) {
        self.context = nsContext
        self.placeholder = ph
        self.organizer = o
    }
    
    public func readImageFromFileSystem(path: String) -> Promise<UIImage?> {
        return Promise<UIImage?>(UIImage(contentsOfFile: path))
    }
    
    internal func readImageFromFileSystemOrDownloadAndStore(photoRecord: PinPhoto) -> Promise<UIImage?> {
        let fullPath = organizer.path(photoRecord.fileName)
        return readImageFromFileSystem(fullPath).then { (image:UIImage?) -> Promise<UIImage?> in
            if image != nil {
                return Promise<UIImage?>(image!)
            }
            return self.organizer.downloadAndStoreImage(photoRecord.sourceUri, to: fullPath)
        }
    }
    
    public func makeAlbum(source: Pin) throws -> Promise<PhotoAlbumModel> {
        var items = [PhotoAlbumMember]()
        //let whatevs = source.valueForKey("photos")
        //let fu = source.photos
        let iterable = source.photos // source.valueForKey("photos") as! NSSet
        for p in iterable {
            if let photo = p as? PinPhoto {
                let m = PhotoAlbumMember(placeholder: self.placeholder, fetcher: self.readImageFromFileSystemOrDownloadAndStore(photo))
                items.append(m)
            }
        }
        let model = PhotoAlbumModel(pin: source, members: Promise<[PhotoAlbumMember]>(items))
        
        return Promise<PhotoAlbumModel>(model)
    }
}