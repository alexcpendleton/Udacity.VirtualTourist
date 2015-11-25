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
    public func images(forLocation: CLLocationCoordinate2D, pageIndex: Int, pageSize: Int) -> Promise<FetchedImageDatum> {
        var results = [String]()
        for i in 1...pageSize {
            let text = "\(pageIndex).\(i)"
            let uri = "https://placeholdit.imgix.net/~text?txtsize=28&txt=\(text)&w=300&h=300"
            results.append(uri)
        }
        return Promise<FetchedImageDatum>(FetchedImageDatum(nextPage: pageIndex + 1, uris: results))
    }
}