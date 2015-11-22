//
//  FlickrImageFetcher.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/21/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import MapKit

public class FlickrImageFetcher : ExternalImageFetchable {
    let secrets: Secrets
    init(secrets:Secrets) {
        self.secrets = secrets
    }
    
    public func images(forLocation: CLLocationCoordinate2D, atMost: Int) -> Promise<[String]> {
        return Promise<[String]>([""])
    }
    
    func getUriList(fromResponse: [NSObject : AnyObject]) -> [String] {
        return ["whoops"]
    }
    
    func createBoundingBoxString(location: CLLocationCoordinate2D) -> String {
        let latitude = location.latitude
        let longitude = location.longitude
        
        /* Fix added to ensure box is bounded by minimum and maximums */
        let bottom_left_lon = max(longitude - BOUNDING_BOX_HALF_WIDTH, LON_MIN)
        let bottom_left_lat = max(latitude - BOUNDING_BOX_HALF_HEIGHT, LAT_MIN)
        let top_right_lon = min(longitude + BOUNDING_BOX_HALF_HEIGHT, LON_MAX)
        let top_right_lat = min(latitude + BOUNDING_BOX_HALF_HEIGHT, LAT_MAX)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }
    
    let BASE_URL = "https://api.flickr.com/services/rest/"
    let METHOD_NAME = "flickr.photos.search"
    let EXTRAS = "url_m"
    let SAFE_SEARCH = "1"
    let DATA_FORMAT = "json"
    let NO_JSON_CALLBACK = "1"
    let BOUNDING_BOX_HALF_WIDTH = 1.0
    let BOUNDING_BOX_HALF_HEIGHT = 1.0
    let LAT_MIN = -90.0
    let LAT_MAX = 90.0
    let LON_MIN = -180.0
    let LON_MAX = 180.0
}