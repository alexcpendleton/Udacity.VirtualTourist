//
//  PhotoOrganizer.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/9/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import FileKit
import UIKit

public class PhotoOrganizer {
    public func makeUniquePath()->String {
        return (documentsDirectory() + "/\(NSUUID().UUIDString).png")
    }
    
    public func save(target: UIImage, path: String, overwrite: Bool) throws {
        let filePath = FKPath(path)
        
        // Don't overwrite any existing files one's there
        if (!overwrite && filePath.exists) {
            return
        }
        
        try target.writeToPath(FKPath(path))
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    
}