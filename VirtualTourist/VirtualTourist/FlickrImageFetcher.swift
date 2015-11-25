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
    public func images(forLocation: CLLocationCoordinate2D, pageIndex: Int, pageSize: Int) -> Promise<FetchedImageDatum> {
        let methodArguments = [
            "method": METHOD_NAME,
            "api_key": secrets.FlickrApiKey,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK,
            "per_page": pageSize.description,
            "page": pageIndex.description,
            "bbox": createBoundingBoxString(forLocation)
        ]
        return getMetaDataFromFlickr(methodArguments).then { (content:[String:AnyObject]) -> Promise<FetchedImageDatum> in
/*
/*
{ "photos": { "page": 1, "pages": "3347", "pageSize": 100, "total": "334602",
"photo": [
{ "id": "22800883667", "owner": "37433113@N00", "secret": "110672bbaa", "server": "5761", "farm": 6, "title": "On a ghost tour in #savannah", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
{ "id": "22899233400", "owner": "128697853@N07", "secret": "772e45f742", "server": "660", "farm": 1, "title": "IMG_2071", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
*/*/
            print("******Response from flickr:")
            print(content)
            print("******End response from flickr.")
         
            let container = content["photos"] as! [String:AnyObject]
            
            let photoTotal = (container["total"] as! NSString).integerValue
            let currentPage = container["page"] as! Int
            let pagesTotal = (container["pages"] as! Int)
            
            let photoArray = container["photo"] as! [[String:AnyObject]]
            let uris: [String] = photoArray.map { $0[self.ImageSizeKey] as! String }
            
            var next = currentPage + 1
            if next > pagesTotal {
                next = 1
            }
            
            let results = FetchedImageDatum(nextPage: next, uris: uris)
            return Promise<FetchedImageDatum>(results)
            
        }
    }
    func readJson(content: NSData) throws -> [String: AnyObject] {
        return try NSJSONSerialization.JSONObjectWithData(content, options: NSJSONReadingOptions.AllowFragments) as! [String : AnyObject]
    }

    func getMetaDataFromFlickr(methodArguments: [String : String]) -> Promise<[String: AnyObject]> {
        //let session = NSURLSession.sharedSession()
        let url = NSURLComponents(string: BASE_URL)
        url!.queryItems = methodArguments.map { NSURLQueryItem(name: $0, value: $1) }
        print("url to flickr: ", url)
        let request = NSURLRequest(URL: url!.URL!)
        
            return NSURLConnection.promise(request).then { (body:NSData) -> Promise<[String: AnyObject]> in
                print("body: ")
                print(body.bytes)
                do {
                    let json = try self.readJson(body)
                    return Promise<[String: AnyObject]>(json)
                } catch let caught as NSError {
                    return Promise<[String: AnyObject]>(error: caught)
                }
            }
        
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
    
    let ImageSizeKey = "url_n"
    let BASE_URL = "https://api.flickr.com/services/rest/"
    let METHOD_NAME = "flickr.photos.search"
    var EXTRAS:String { get { return ImageSizeKey } }
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