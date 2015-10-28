//
//  PhotoSliderCollectionData.swift
//
//  Created by Jeff on 8/1/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import Foundation

// Load demo images into PhotosDataSource model

extension PhotoSliderCollectionController {

    func loadPhotoData() -> PhotosDataSource? {
        
        var photosData = PhotosDataSource()

        photosData.addPhotoURL("DeerNextDoor.jpg")
        photosData.addPhotoURL("SalmonGlacierClouds.jpg")
        photosData.addPhotoURL("FallLeaves.jpg")
        photosData.addPhotoURL("SunsetOnLakeMurrayDam.jpg")
        photosData.addPhotoURL("ForestFireAftermath.jpg")

        return photosData
    }
    
}
