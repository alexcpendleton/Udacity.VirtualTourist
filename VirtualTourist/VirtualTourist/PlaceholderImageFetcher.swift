//
//  PlaceholderImageFetcher.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/3/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import PromiseKit
import MapKit
import DRImagePlaceholderHelper

public class PlaceholderImageFetcher : ExternalImageFetchable {
    public var size = CGSize(width: 300, height: 300)
    public func images(forLocation: CLLocationCoordinate2D, pageIndex: Int, perPage: Int) -> Promise<FetchedImageDatum> {
        var results = [String]()
        for _ in 1...perPage {
            // We use an empty URI to force usage of a placeholder
            // Sort of silly, but it's just for testing code...
            results.append("")
        }
        return Promise<FetchedImageDatum>(FetchedImageDatum(nextPage: 2, uris: results))
    }
    
    var placeholderMaker = { DRImagePlaceholderHelper.sharedInstance() as! DRImagePlaceholderHelper }()
    
    public func onePlaceholder(color:UIColor = UIColor.blueColor()) -> UIImage {
        return placeholderMaker.placerholderImageWithSize(size, text: "", fillColor: color)
    }
}