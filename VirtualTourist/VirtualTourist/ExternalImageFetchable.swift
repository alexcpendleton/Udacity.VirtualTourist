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
    func images(forLocation:CLLocationCoordinate2D, pageIndex:Int, perPage:Int) -> Promise<FetchedImageDatum>
}

public struct FetchedImageDatum {
    init(nextPage: Int, uris: [String]) {
        nextPageIndex = nextPage
        urisForPage = uris
    }
    public var urisForPage: [String]
    public var nextPageIndex: Int
}