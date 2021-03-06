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
import PromiseKit

public class PhotoOrganizer {
    
    public func makeUniquePng()->String {
        return "/\(NSUUID().UUIDString).png"
    }
    
    /**
     Gives you the path of a file inside the documents directory. This is the
     default location for stored photos, and we keep just the file's name in
     the data store.
     - Parameter fromFileName: The file name to include in the full documents path.
     */
    public func path(fromFileName: String) -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent(fromFileName)
    }
    
    /**
     Writes an image to the desired path. If overwrite is true, and the path 
     already exists, the existing file will be overwritten. Otherwise, nothing
     will happen.
      - Parameter target: The image to be saved.
      - Parameter path: The full destination path, it does not default to using the documents directory.
      - Parameter overwrite: Whether a file with the same path should be overwritten.
     */
    public func save(target: UIImage, path: String, overwrite: Bool) throws {
        let filePath = FKPath(path)
        
        // Don't overwrite any existing files one's there
        if (!overwrite && filePath.exists) {
            return
        }
        
        try target.writeToPath(FKPath(path))
    }
    /**
     A helper to get to the app's document directory.
     */
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    public func downloadAndStoreImage(from: String, to: String)->Promise<UIImage?> {
        if from.isEmpty { return Promise<UIImage?>(nil) }
        let imageRequest: NSURLRequest = NSURLRequest(URL: NSURL(string: from)!)
        return NSURLSession.sharedSession().promise(imageRequest).then({ (data:NSData) -> Promise<UIImage?> in
            let image = UIImage(data: data)
            
            do {
                try self.save(image!, path: to, overwrite: false)
            } catch _ {
                // If for some reason we fail to save to the file system
                // it's not the end of the world, no point in blowing up.
                // We still have the image
            }
            return Promise<UIImage?>(image)
        })
    }
    
    public func delete(fullPath: String) {
        try? FKPath(fullPath).deleteFile()
    }
    
    
}