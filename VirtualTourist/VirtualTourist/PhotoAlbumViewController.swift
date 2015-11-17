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
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var newCollectionTrigger: UIButton!
    
    var tapRecognizer: UITapGestureRecognizer!
    
    public var model: PhotoAlbumModel!
    private var dataSource:[PhotoAlbumMember]?
    public var useTestingData = true
    lazy public var mediator = { AppDelegate.sharedInstance().albumMediator }()

    
    @IBAction func newCollectionOnTouchUpInside(sender:AnyObject?) {
        // Store the coordinate for later
        let coordinate = model.pin.coordinate
        // Trash the old pin, it's of no use to us anymore
        let app = AppDelegate.sharedInstance()
        app.stackManager.managedObjectContext.deleteObject(model.pin)
        
        // Fetch a new album
        let coordinator = AppDelegate.sharedInstance().albumCoordinators.new
        try! coordinator.makeAlbum(coordinate).then { (body:PhotoAlbumModel) -> Promise<PhotoAlbumModel> in
            self.mediator.album = body
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView.reloadData()
            })
            return Promise<PhotoAlbumModel>(body)
        }
    }
    
    @IBAction func doneOnTouchUpInside(sender: AnyObject?) {
        close()
    }
    
    public func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if model == nil {
            model = mediator.album
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        tapRecognizer = UITapGestureRecognizer(target: self, action: "onSingleTap:")
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.view.backgroundColor = self.view.backgroundColor?.colorWithAlphaComponent(0.75)
        
        super.viewWillAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadAlbum()
    }
    
    func onSingleTap(sender:UIGestureRecognizer) {
        // See if they clicked outside the collection view, meaning
        // we should close the view
        sender.locationInView(collectionView)
    }
    
    public func loadAlbum() -> Promise<[PhotoAlbumMember]> {
        // Loading the album includes looking up how many photos
        // are at a given location. We want to show a spinner while
        // that happens. It might not need to happen for a cached album.
        // After that finishes, we then start loading in each photo 
        // individually after we've added placeholder image views for
        // each counted photo at this location.
        
        albumActivityIndicator.startAnimating()
        collectionView.backgroundColor = collectionView.backgroundColor?.colorWithAlphaComponent(0.75)
        
        return model.members.then { (body:[PhotoAlbumMember]) -> Promise<[PhotoAlbumMember]>
            in
            self.dataSource = body
            self.collectionView.reloadData()
            self.collectionView.backgroundColor = self.collectionView.backgroundColor?.colorWithAlphaComponent(1)
            self.albumActivityIndicator.stopAnimating()
            self.loadMap()
            return Promise<[PhotoAlbumMember]>(body)
        }
    }
    
    func loadMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = model.coordinate
        map.addAnnotation(annotation)
        map.setCenterCoordinate(model.coordinate, animated: false)
        map.setRegion(MKCoordinateRegion(center: model.coordinate, span: MKCoordinateSpanMake(0.3, 0.3)), animated: false)
        
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
