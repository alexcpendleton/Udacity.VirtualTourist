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
    
    init(nsContext: NSManagedObjectContext, placeholder ph:UIImage) {
        self.context = nsContext
        self.placeholder = ph
    }
    
    public func readImageFromFileSystem(path: String) -> Promise<UIImage> {
        return Promise<UIImage>(UIImage(contentsOfFile: path)!)
    }
    
    public func makeAlbum(source: Pin) throws -> Promise<PhotoAlbumModel> {
        var items = [PhotoAlbumMember]()

        for p in source.photos {
            if let photo = p as? PinPhoto {
                let m = PhotoAlbumMember(placeholder: self.placeholder, fetcher: readImageFromFileSystem(photo.filePath))
                items.append(m)
            }
        }
        let model = PhotoAlbumModel(coordinate: source.coordinate, members: Promise<[PhotoAlbumMember]>(items))
        return Promise<PhotoAlbumModel>(model)
    }
}