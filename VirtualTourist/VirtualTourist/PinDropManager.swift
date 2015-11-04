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

public class PinDropManager : NSObject {
    init(mapView mv: MKMapView, delegate d: PinDropManagerDelegate? = nil) {
        mapView = mv
        delegate = d
    }
    var pressRecognizer: UILongPressGestureRecognizer?
    let mapView: MKMapView
    public var delegate: PinDropManagerDelegate? = nil
    
    func register() {
        pressRecognizer = UILongPressGestureRecognizer(target: self, action: "onLongPress:")
        mapView.addGestureRecognizer(pressRecognizer!)
    }
    
    public func onLongPress(sender:UIGestureRecognizer) -> Void {
        let location = sender.locationInView(mapView)
        let asCoordinate = mapView.convertPoint(location, toCoordinateFromView: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = asCoordinate
        dropPin(annotation)
    }
    
    func dropPin(annotation: MKPointAnnotation) {
        // TODO: Make it so you can drag the pin around
        // TODO: Vibration when long press is registered?
        mapView.addAnnotation(annotation)
    }
}

public protocol PinDropManagerDelegate {
    func pinDropped(annotation: MKPointAnnotation)
}
