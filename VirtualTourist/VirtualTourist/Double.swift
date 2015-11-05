//
//  Double.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/4/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

extension Double {
    func delay(closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(self * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}