//
//  PlaceholditFetcher.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/12/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import PromiseKit
import MapKit

public class PlaceholditFetcher : ExternalImageFetchable {
    public func images(forLocation: CLLocationCoordinate2D, atMost: Int) -> Promise<[String]> {
        var results = [String]()
        for i in 1...atMost {
            let uri = "https://placeholdit.imgix.net/~text?txtsize=28&txt=\(i)&w=300&h=300"
            results.append(uri)
        }
        return Promise<[String]>(results)
    }
}