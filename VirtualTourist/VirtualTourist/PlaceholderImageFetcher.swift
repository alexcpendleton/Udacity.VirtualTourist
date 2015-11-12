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
    public var size = CGSize(width: 100, height: 100)

    public func images(forLocation: CLLocationCoordinate2D, atMost: Int) -> Promise<[String]> {
        var results = [String]()
        for _ in 1...atMost {
            // We use an empty URI to force usage of a placeholder
            // Sort of silly, but it's just for testing code...
            results.append("")
        }
        return Promise<[String]>(results)
    }
    
    var placeholderMaker = { DRImagePlaceholderHelper.sharedInstance() as! DRImagePlaceholderHelper }()
    
    public func onePlaceholder(color:UIColor = UIColor.blueColor()) -> UIImage {
        return placeholderMaker.placerholderImageWithSize(size, text: "", fillColor: color)
    }
}