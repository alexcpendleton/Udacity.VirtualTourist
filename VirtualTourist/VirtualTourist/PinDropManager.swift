//
//  PinDropManager.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/3/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

public class PinDropManager : NSObject {
    init(mapView mv: MKMapView, context c: NSManagedObjectContext, delegate d: PinDropManagerDelegate? = nil) {
        mapView = mv
        delegate = d
        context = c
    }
    var pressRecognizer: UILongPressGestureRecognizer?
    let mapView: MKMapView
    let context: NSManagedObjectContext
    public var delegate: PinDropManagerDelegate? = nil
    
    func register() {
        pressRecognizer = UILongPressGestureRecognizer(target: self, action: "onLongPress:")
        mapView.addGestureRecognizer(pressRecognizer!)
    }
    
    public func onLongPress(sender:UIGestureRecognizer) -> Void {
        let location = sender.locationInView(mapView)
        let asCoordinate = mapView.convertPoint(location, toCoordinateFromView: mapView)
        
        // Remove the gesture recognition 
        mapView.removeGestureRecognizer(pressRecognizer!)
        
        let annotation = AlbumPointAnnotation(pin: Pin(lat: asCoordinate.latitude, lon: asCoordinate.longitude, context: context))
        annotation.coordinate = asCoordinate
        dropPin(annotation)
    }
    
    func dropPin(annotation: AlbumPointAnnotation) {
        // TODO: Make it so you can drag the pin around
        // TODO: Vibration when long press is registered?
        mapView.addAnnotation(annotation)
        delegate?.pinDropped(annotation)
    }
}

public protocol PinDropManagerDelegate {
    func pinDropped(annotation: AlbumPointAnnotation)
}
