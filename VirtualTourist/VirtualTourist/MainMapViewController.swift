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
import CoreData

public class MainMapViewController : UIViewController, MKMapViewDelegate, PinDropManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    public var startingPoint: CLLocationCoordinate2D?
    
    public var appConfigManager: AppConfigManager!
    public var pinDropManager: PinDropManager!
    public var metadataFetcher: ImageMetaDataFetcher!
    public var albumCoordinators: (new:NewAlbumCoordinator, existing:ExistingAlbumCoordinator)!
    public var albumMediator: WorkingAlbumMediator!
    public var context: NSManagedObjectContext!
    
    var loadedPins = [Pin]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let app = AppDelegate.sharedInstance()
        appConfigManager = app.appConfigManager
        metadataFetcher = app.metaDataFetcher
        albumCoordinators = app.albumCoordinators
        albumMediator = app.albumMediator
        context = app.stackManager.managedObjectContext
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let record = appConfigManager.record
        if startingPoint == nil {
            startingPoint = record.coordinate
            zoomTo(startingPoint!)
        }
        let region = MKCoordinateRegionMake(startingPoint!, makeSpan(record))
        map.setRegion(region, animated: true)
        
        pinDropManager = PinDropManager(mapView: map, context: context, delegate: self)
        pinDropManager.register()
        
        loadExistingAlbumsAsAnnotations()
    }
    
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
    
    public func loadExistingAlbumsAsAnnotations() {
        let request = NSFetchRequest(entityName: "Pin")
        do {
            for record in try context.executeFetchRequest(request) {
                if let pin = record as? Pin {
                    loadedPins.append(pin)
                    map.addAnnotation(AlbumPointAnnotation(pin: pin))
                }
            }
        }
        catch _ {
            print("There was an issue fetching the pins...")
        }
    }
    
    
    public func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let region = mapView.region
        appConfigManager.record.longitudeDelta = region.span.longitudeDelta
        appConfigManager.record.latitudeDelta = region.span.latitudeDelta
        appConfigManager.save()
        print(appConfigManager.record)
    }
    
    public func pinDropped(annotation: AlbumPointAnnotation) {
        try! albumCoordinators.new.makeAlbum(annotation.coordinate).then {
            self.presentAlbum($0)
        }
    }
    
    public func presentAlbum(album: PhotoAlbumModel) {
        print("presentingAlbum : ", album)
        let vc = storyboard?.instantiateViewControllerWithIdentifier("PhotoAlbumRootNavigationController")
            as! UINavigationController
        self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        albumMediator.album = album
        //navigationController?.pushViewController(vc, animated: true)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    public func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let pinAnnotation = view.annotation as? AlbumPointAnnotation {
            try! albumCoordinators.existing.makeAlbum(pinAnnotation.pin!).then({ (model:PhotoAlbumModel) -> Promise<PhotoAlbumModel> in
                self.presentAlbum(model)
                return Promise<PhotoAlbumModel>(model)
            })
        }
    }
}

public class AlbumPointAnnotation : MKPointAnnotation {
    var pin: Pin?
    init(pin: Pin?) {
        super.init()
        self.pin = pin
        if pin != nil {
            self.coordinate = pin!.coordinate
        }
    }
}