//
//  Secrets.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/21/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class Secrets {
    init(key:String) {
        FlickrApiKey = key
    }
    public var FlickrApiKey = ""
    
    init(fromPlistAtPath: String) {
        if let loaded = NSDictionary(contentsOfFile: fromPlistAtPath) as? [String:AnyObject] {
            FlickrApiKey = loaded["FlickrApiKey"] as! String
        }
    }
}