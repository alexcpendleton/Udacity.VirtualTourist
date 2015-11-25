//
//  AlbumPointAnnotation.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/24/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import MapKit

public class AlbumPointAnnotation : MKPointAnnotation {
    var pin: Pin?
    init(pin: Pin?) {
        super.init()
        self.pin = pin
        if pin != nil {
            self.coordinate = pin!.coordinate
            _ = pin!.photos
        }
    }
}