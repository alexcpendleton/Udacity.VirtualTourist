//
//  ImageMetadataFetcher.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/6/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import MapKit

public class ImageMetaDataFetcher {
    let placeholderMaker: PlaceholderImageFetcher
    
    public var albumDelay: Double = 2.0
    public var imageDelay: Double = 2.0
    
    init(maker:PlaceholderImageFetcher) {
        placeholderMaker = maker
    }
    
    func delayedImageFetcher() -> Promise<UIImage?> {
        return Promise<UIImage?> { fulfill, reject in
            imageDelay.delay {
                fulfill(self.afterLoad())
            }
        }
    }
    
    func afterLoad() -> UIImage? {
        return placeholderMaker.onePlaceholder(UIColor.greenColor())
    }
    
    func beforeLoad() -> UIImage? {
        return placeholderMaker.onePlaceholder(UIColor.redColor())
    }
    
    public func fetch(forLocation: CLLocationCoordinate2D) -> Promise<[PhotoAlbumMember]> {
        return Promise<[PhotoAlbumMember]> { fulfill, reject in
            albumDelay.delay {
                var result = [PhotoAlbumMember]()
                for _ in 1...25 {
                    let n = PhotoAlbumMember(placeholder:self.beforeLoad()!, fetcher: self.delayedImageFetcher())
                    result.append(n)
                }
                fulfill(result)
            }
        }
    }
}
