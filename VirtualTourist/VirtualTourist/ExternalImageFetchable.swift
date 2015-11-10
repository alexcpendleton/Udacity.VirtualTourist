//
//  ExternalImageFetchable.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/3/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import MapKit
import PromiseKit

public protocol ExternalImageFetchable {
    func images(forLocation:CLLocationCoordinate2D) -> Promise<[ImageRepresentable]>
}

public protocol ImageRepresentable {
    var uri: String {get}
}