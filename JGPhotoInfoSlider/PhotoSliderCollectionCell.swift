//
//  PhotoSliderCollectionCell.swift
//
//  Created by Jeff on 8/1/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import UIKit

class PhotoSliderCollectionCell: UICollectionViewCell {
    
    // the cell's contents: an ImageViewWithInfoCaption object
    var photoImageView: ImageViewWithInfoCaption!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /// assign photoImageView
        wireupColaboratingObjects(contentView)
        /// ImageViewWithInfoCaption required - can't work without it
        if photoImageView == nil {exitFailLog("ImageViewWithInfoCaption object not located in cell")}
        /// set contentView container bounds
        contentView.frame = bounds
        // set autoresizing mask
        contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    /// get the width
    var width: CGFloat {
        return (self.frame.size.width)
    }
    
    /// origin.x at the moment for parallax
    var originX: CGFloat {
        return (self.frame.origin.x)
    }
    
    /// set the photo image
    func displayPhoto(img: UIImage) {
        photoImageView.image = img
    }
    
    /// set the metadata caption
    func loadMetadata(metadata: PhotoMetadataModel) {
        photoImageView.setCaption(metadata)
    }
    
    /// set the origin.x offset for parallax
    func offsetX(offset: CGFloat) {
        photoImageView.frame.origin.x = offset
    }
    
    /// locate an ImageViewWithInfoCaption object
    /// assign it to photoImageView
    private func wireupColaboratingObjects(view: UIView) {
        for subview in view.subviews as [AnyObject] {
            if let ImageViewWithInfoCaptionObject = subview as? ImageViewWithInfoCaption {
                photoImageView = ImageViewWithInfoCaptionObject
            }
        }
    }
    
    /// print message, function, file, line number then exit
    private func exitFailLog(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
        print("\(message):\r\(function) : \(file) Line:\(line)\r")
        exit(EXIT_FAILURE)
    }

}

