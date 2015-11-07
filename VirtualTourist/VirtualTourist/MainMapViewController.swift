//
//  MainMapViewController.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/2/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import PromiseKit

public class MainMapViewController : UIViewController, MKMapViewDelegate, PinDropManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    public var startingPoint: CLLocationCoordinate2D?
    
    public var appConfigManager: AppConfigManager!
    public var pinDropManager: PinDropManager!
//    public var imageFetcher: PlaceholderImageFetcher!
    public var metadataFetcher: ImageMetaDataFetcher!
    
    public func zoomTo(coordinate:CLLocationCoordinate2D) {
        map.setCenterCoordinate(coordinate, animated: true)
        appConfigManager.record.latitude = coordinate.latitude
        appConfigManager.record.longitude = coordinate.longitude
        appConfigManager.save()
    }
    
    func makeSpan(config: AppConfiguration) -> MKCoordinateSpan {
        let lat = config.latitudeDelta.doubleValue
        let lon = config.longitudeDelta.doubleValue
        let span = MKCoordinateSpanMake(lat, lon)
        return span
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let app = AppDelegate.sharedInstance()
        appConfigManager = app.appConfigManager
        metadataFetcher = app.metaDataFetcher
        
        let record = appConfigManager.record
        if startingPoint == nil {
            startingPoint = record.coordinate
            zoomTo(startingPoint!)
        }
        let region = MKCoordinateRegionMake(startingPoint!, makeSpan(record))
        map.setRegion(region, animated: true)
        
        pinDropManager = PinDropManager(mapView: map, delegate: self)
        pinDropManager.register()
    }
    
    public func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let region = mapView.region
        appConfigManager.record.longitudeDelta = region.span.longitudeDelta
        appConfigManager.record.latitudeDelta = region.span.latitudeDelta
        appConfigManager.save()
        print(appConfigManager.record)
    }
    
    public func pinDropped(annotation: MKPointAnnotation) {
        let loader = metadataFetcher.fetch(annotation.coordinate)
        let album = PhotoAlbumModel(coordinate: annotation.coordinate, members: loader)
        presentAlbum(album)
    }
    
    public func presentAlbum(album: PhotoAlbumModel) {
        print("presentingAlbum : ", album)
        let vc = storyboard?.instantiateViewControllerWithIdentifier("PhotoAlbumViewController")
            as! PhotoAlbumViewController
        vc.model = album
        navigationController?.pushViewController(vc, animated: true)
        //presentViewController(vc, animated: true, completion: nil)
    }
}

