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
    init(coordinate: CLLocationCoordinate2D, members: Promise<[PhotoAlbumMember]>) {
        self.coordinate = coordinate
        self.members = members
    }
    public var members: Promise<[PhotoAlbumMember]>
    public var coordinate: CLLocationCoordinate2D
}