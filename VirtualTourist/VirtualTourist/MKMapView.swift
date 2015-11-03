//
//  MKMapView.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/2/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    func zoomToCoordinate(coordinate:CLLocationCoordinate2D, distance: CLLocationDistance = 6000) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, distance, distance)
        self.setCenterCoordinate(coordinate, animated: true)
        self.setRegion(region, animated: true)
    }
}