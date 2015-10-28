//
//  PhotosDataSource.swift
//
//  Created by Jeff on 7/23/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import Foundation

/// Data source structure 
/// stores photo URLS in array
/// - gets: photo NSData by index number
struct PhotosDataSource {
    
    private var URLs = [NSString]()
    
    /// use to load the photo array 
    /// - parameter newURL: as String
    mutating func addPhotoURL(newURL: String) {
        URLs.append(newURL)
    }
    
    /// cell count used by collection controller to
    /// determine number of photos/cells
    /// - returns: array count as Int
    internal func count() -> Int {
        return URLs.count
    }
    
    /// get and return photo as NSData
    /// - parameter index: as integer, used to sync with cell
    /// - returns: photo as NSData or nil
    internal func getPhotoDataByIndex(index: Int) -> NSData? {
        
        if index >= URLs.count {
            return nil
        }
        
        if URLs[index].pathComponents.count == 1 {
            return NSData(named: URLs[index] as String)
        }
        
        return nil
    }
        

}
