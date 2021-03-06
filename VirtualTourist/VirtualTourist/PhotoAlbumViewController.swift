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
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var tapRecognizer: UITapGestureRecognizer!
    
    public var model: PhotoAlbumModel!
    private var dataSource:[PhotoAlbumMember]?
    public var useTestingData = true
    
    lazy public var app =  { return AppDelegate.sharedInstance() }()
    public var mediator: WorkingAlbumMediator { get { return app.albumMediator } }
    public var albumDestroyer: AlbumDestroyer  { get { return app.albumDestroyer } }
    public var albumCoordinators: (new:NewAlbumCoordinator, existing:ExistingAlbumCoordinator) { get { return app.albumCoordinators } }
    public var pageSize: Int { get { return app.pageSize } }
    
    @IBAction func newCollectionOnTouchUpInside(sender:AnyObject?) {
        // Store the coordinate for later
        let coordinate = model.pin.coordinate
        try? albumDestroyer.destroy(model.pin.photos.map { $0 as! PinPhoto })
        // Fetch the next page of images
        let coordinator = albumCoordinators.new
        let nextPage = model.pin.nextPageIndex.integerValue
        try! coordinator.makeAlbum(coordinate, pageIndex: nextPage, pageSize: pageSize, pinRecord: model.pin).then { (body:PhotoAlbumModel) -> Promise<PhotoAlbumModel> in
            self.mediator.album = body
            self.model = self.mediator.album
            self.loadAlbum()
            self.collectionView.reloadData()
            return Promise<PhotoAlbumModel>(body)
        }
    }
    
    @IBAction func doneOnTouchUpInside(sender: AnyObject?) {
        close()
    }
    
    @IBAction func deleteSelectedTouchUpInside(sender:AnyObject?) {
        deleteSelected()
    }
    
    public func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func deleteSelected() {
        let deleteable = dataSource!.filter{$0.isSelected && $0.associate != nil}
        for item in deleteable {
            try? albumDestroyer.destroy(item.associate!)
        }
        dataSource = dataSource!.filter{!$0.isSelected}
        collectionView.reloadData()
    }
    
    public override func viewDidLoad() {
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        super.viewDidLoad()
        if model == nil {
            model = mediator.album
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
        cell.setSelection(item.isSelected)
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        updateCellSelection(collectionView, indexPath: indexPath, selectionStatus: true)
    }
    
    public func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        updateCellSelection(collectionView, indexPath: indexPath, selectionStatus: false)
    }
    
    func updateCellSelection(collectionView: UICollectionView, indexPath: NSIndexPath, selectionStatus: Bool) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoAlbumCollectionViewCell
        let item = dataSource![indexPath.row]
        item.isSelected = selectionStatus
        cell.setSelection(selectionStatus)
        
        deleteButton.enabled = dataSource!.filter{$0.isSelected}.count > 0
    }
}

public class PhotoAlbumCollectionViewCell : UICollectionViewCell {
    @IBOutlet public weak var photo: UIImageView!
    @IBOutlet public weak var selectionIndicator: UIImageView!
    
    public func setSelection(shouldBeSelected: Bool) {
        selectionIndicator.hidden = !shouldBeSelected
    }
}

