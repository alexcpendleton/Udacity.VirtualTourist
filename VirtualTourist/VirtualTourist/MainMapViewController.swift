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

public class MainMapViewController : UIViewController, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    public var startingPoint: CLLocationCoordinate2D?
    public var appConfigManager: AppConfigManager!
    
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
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        appConfigManager = AppConfigManager.sharedInstance
        let record = appConfigManager.record
        if startingPoint == nil {
            startingPoint = record.coordinate
            zoomTo(startingPoint!)
        }
        let region = MKCoordinateRegionMake(startingPoint!, makeSpan(record))
        map.setRegion(region, animated: true)
        //map.setRegion(MKCoordinateRegion(center: startingPoint!, span: MKCoordinateSpanMake(record.latitudeDelta.doubleValue, record.longitudeDelta.doubleValue)) animated: true)
    }
    
    public func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let region = mapView.region
        print("region changed", region.span.longitudeDelta)
        appConfigManager.record.longitudeDelta = region.span.longitudeDelta
        appConfigManager.record.latitudeDelta = region.span.latitudeDelta
        appConfigManager.save()
    }
}

public class AppConfigManager {
    public var record: AppConfiguration!
    let repo: NsmAppConfigurationRepository!
    let factory: NsmAppConfigurationFactory!
    init(repo r: NsmAppConfigurationRepository, factory f: NsmAppConfigurationFactory) {
        repo = r
        factory = f
    }
    
    func save() {
        try! repo.save()
    }
    
    public static var sharedInstance: AppConfigManager!
}