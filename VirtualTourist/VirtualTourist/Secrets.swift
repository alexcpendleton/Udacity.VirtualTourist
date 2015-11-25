//
//  Secrets.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/21/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class Secrets {
    init(key:String, secret:String) {
        FlickrApiKey = key
        FlickrApiSecret = secret
    }
    public var FlickrApiKey = ""
    public var FlickrApiSecret = ""
    
    init(fromPlistAtPath: String) {
        if let loaded = NSDictionary(contentsOfFile: fromPlistAtPath) as? [String:AnyObject] {
            FlickrApiKey = loaded["FlickrApiKey"] as! String
            FlickrApiSecret = loaded["FlickrApiSecret"] as! String
        } else {
            print("INSTRUCTOR: Be sure you set your API key in AppDelegate or put it into a plist file. Mine is in a Secrets.plist file which I don't keep in git.")
        }
    }
}