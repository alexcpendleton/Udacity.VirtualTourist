//
//  WorkingAlbumMediator.swift
//  VirtualTourist
//
//  Created by Alex Pendleton on 11/11/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

/**
 This class is meant to contain a single Album that gets passed among
 the necessary ViewControllers to simplify the flow layouts.
 */
public class WorkingAlbumMediator {
    public var album: PhotoAlbumModel?
    
    public func clear() {
        album = nil
    }
}
