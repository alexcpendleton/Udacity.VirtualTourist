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

public class PlaceholderImageFetcher {
    public var size = CGSize(width: 100, height: 100)
    public func images(forLocation: CLLocationCoordinate2D) -> Promise<[AnyObject]> {
        let result = Promise<[AnyObject]>(getImages())
        return result
    }
    var placeholderMaker = { DRImagePlaceholderHelper.sharedInstance() as! DRImagePlaceholderHelper }()
    
    public func getImages(amount:Int = 50) -> [AnyObject] {
        var results = [AnyObject]()
        for _ in 1...amount {
            let image = onePlaceholder()
            results.append(image)
        }
        return results
    }
    
    public func onePlaceholder(color:UIColor = UIColor.blueColor()) -> UIImage {
        return placeholderMaker.placerholderImageWithSize(size, text: "", fillColor: color)
    }
}