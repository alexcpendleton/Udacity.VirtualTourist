//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/4/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import PromiseKit
import DRImagePlaceholderHelper

public class PhotoAlbumViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var albumActivityIndicator: UIActivityIndicatorView!

    public var model: PhotoAlbumModel!
    private var dataSource:[PhotoAlbumMember]?
    public var useTestingData = true
    
    public override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = self.view.backgroundColor?.colorWithAlphaComponent(0.75)
        
        super.viewWillAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadAlbum()
    }
    
    public func loadAlbum() -> Promise<[PhotoAlbumMember]> {
        // Loading the album includes looking up how many photos
        // are at a given location. We want to show a spinner while
        // that happens. It might not need to happen for a cached album.
        // After that finishes, we then start loading in each photo 
        // individually after we've added placeholder image views for
        // each counted photo at this location.
        
        albumActivityIndicator.startAnimating()
        
        return model.members.then { (body:[PhotoAlbumMember]) -> Promise<[PhotoAlbumMember]>
            in
            self.dataSource = body
            self.collectionView.reloadData()
            self.albumActivityIndicator.stopAnimating()
            return Promise<[PhotoAlbumMember]>(body)
        }
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource == nil ? 0 : dataSource!.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoAlbumCell", forIndexPath: indexPath) as! PhotoAlbumCollectionViewCell
        // When the member's image is nil, go fetch it
        let item = self.dataSource![indexPath.row]
        if item.image == nil {
            cell.photo.image = item.placeholder
            item.fetch().then { _ in cell.photo.image = item.image }
        } else {
            cell.photo.image = item.image
        }
        return cell
    }
}

public class PhotoAlbumCollectionViewCell : UICollectionViewCell {
    @IBOutlet public weak var photo: UIImageView!
}

public class PhotoAlbumModel {
    init(coordinate: CLLocationCoordinate2D, members: Promise<[PhotoAlbumMember]>) {
        self.coordinate = coordinate
        self.members = members
    }
    public var members: Promise<[PhotoAlbumMember]>
    public var coordinate: CLLocationCoordinate2D
}

public class PhotoAlbumMember {
    init(placeholder: UIImage, fetcher:Promise<UIImage>) {
        self.fetcher = fetcher
        self.placeholder = placeholder
    }
    
    public var image: UIImage?
    public var placeholder: UIImage
    public var isSelected = false
    public var fetcher: Promise<UIImage>

    public func fetch() -> Promise<PhotoAlbumMember> {
        return when(fetcher).then { (fetchedImage: [UIImage]) -> Promise<PhotoAlbumMember> in
            self.image = fetchedImage.first!
            return Promise<PhotoAlbumMember>(self)
        }
    }
}