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
    public var model: PhotoAlbumModel!
    
    private var dataSource:[PhotoAlbumMember]?
    public var useTestingData = true
    
    public override func viewWillAppear(animated: Bool) {
        if useTestingData {
            let promise = Promise<[PhotoAlbumMember]> { fulfill, reject in
                2.0.delay {
                    var results = [PhotoAlbumMember]()
                    let placeholderMaker = DRImagePlaceholderHelper.sharedInstance() as! DRImagePlaceholderHelper
                    let size = CGSize(width: 200, height: 200)
                    for _ in 1...50 {
                        let placeholder = placeholderMaker.placerholderImageWithSize(size, text: "Loading...", fillColor: UIColor.redColor())
                        let fetcher = Promise<UIImage> { f2, r2 in
                            2.0.delay {
                                f2(placeholderMaker.placerholderImageWithSize(size, text: "Done!", fillColor: UIColor.blueColor()))
                            }
                        }
                        results.append(PhotoAlbumMember(placeholder: placeholder, fetcher: fetcher))
                        fulfill(results)
                    }
                }
            }
            model = PhotoAlbumModel(coordinate: CLLocationCoordinate2DMake(0, 0), members: promise)
        }
        
        super.viewWillAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Look in the model, it should have an 
        // array of placeholder images. For each of those
        // go through and fetch each individually to fill
        // in the appropriate image
        model.members.then {
            self.dataSource = $0
            self.collectionView.reloadData()
            
        }
//        dispatch_promise
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource == nil ? 0 : dataSource!.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoAlbumCell", forIndexPath: indexPath)
        
        return cell
    }
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