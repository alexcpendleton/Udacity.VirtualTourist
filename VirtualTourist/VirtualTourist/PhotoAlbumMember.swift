//
//  PhotoAlbumMember.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/9/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import PromiseKit

public class PhotoAlbumMember {
    init(placeholder: UIImage, fetcher:Promise<UIImage?>) {
        self.fetcher = fetcher
        self.placeholder = placeholder
    }
    
    public var image: UIImage?
    public var placeholder: UIImage
    public var fetcher: Promise<UIImage?>
    
    public func fetch() -> Promise<PhotoAlbumMember> {
        return when(fetcher).then { (fetchedImage: [UIImage?]) -> Promise<PhotoAlbumMember> in
            self.image = fetchedImage.first!
            return Promise<PhotoAlbumMember>(self)
        }
    }
}