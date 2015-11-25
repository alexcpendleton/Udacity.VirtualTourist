//
//  PhotoAlbumModel.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/9/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import MapKit
import PromiseKit

public class PhotoAlbumModel {
    init(pin: Pin, members: Promise<[PhotoAlbumMember]>) {
        self.pin = pin
        self.members = members
    }
    public var pin: Pin
    public var members: Promise<[PhotoAlbumMember]>
    public var coordinate: CLLocationCoordinate2D {
        get { return pin.coordinate }
    }
}