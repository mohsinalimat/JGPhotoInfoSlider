//
//  JGMetadataCaptionLabel.swift
//
//  Created by Jeff on 7/28/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import UIKit

/// A designable UILabel
/// formats itself
/// combining user selected Inspectables
/// and data from PhotoMetadataModel
@IBDesignable
public class JGMetadataCaptionLabel: UILabel {
    
    // MARK: Inspectables
    
    @IBInspectable var colorLabel: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65) { didSet { setColors() } }
    
    @IBInspectable var colorText: UIColor = UIColor.whiteColor() { didSet { setColors() } }

    @IBInspectable var lineHeight: CGFloat = 20         { didSet { makeAttributedCaption(metadataForIBInspectable) } }
    
    @IBInspectable var photoTitle: Bool = true          { didSet { makeAttributedCaption(metadataForIBInspectable) } }
    @IBInspectable var photoDescription: Bool = true    { didSet { makeAttributedCaption(metadataForIBInspectable) } }
    @IBInspectable var aperture: Bool = true            { didSet { makeAttributedCaption(metadataForIBInspectable) } }
    @IBInspectable var exposure: Bool = true            { didSet { makeAttributedCaption(metadataForIBInspectable) } }
    @IBInspectable var camera: Bool = true              { didSet { makeAttributedCaption(metadataForIBInspectable) } }
    @IBInspectable var focalLength: Bool = true         { didSet { makeAttributedCaption(metadataForIBInspectable) } }
    
    @IBInspectable var pixelSize: Bool = true           { didSet { makeAttributedCaption(metadataForIBInspectable) } }
    @IBInspectable var dateTaken: Bool = true           { didSet { makeAttributedCaption(metadataForIBInspectable) } }
    @IBInspectable var keyWords: Bool = true            { didSet { makeAttributedCaption(metadataForIBInspectable) } }
    @IBInspectable var gps: Bool = true                 { didSet { makeAttributedCaption(metadataForIBInspectable) } }
    
    // MARK: Private vars
    
    private var metadataForIBInspectable = PhotoMetadataModel()
    
    private let multiplicationSign = "\u{2715}" //0455

    // MARK: Initialize
    
    func initMaster() {
        self.numberOfLines = 16
        self.userInteractionEnabled = true
        
        setColors()
        initMetadataForIBInspectable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initMaster()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initMaster()
    }

    
    override public func prepareForInterfaceBuilder() {
        initMaster()
    }
    
    private func setColors() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        self.textColor = UIColor.whiteColor()
    }
    
    // MARK: Main public function
    
    /// ### main public function
    /// build & set (self)Label's attributedText based on the IBInspectables set in the storyboard
    /// using the supplied metadata
    /// - parameter metadata: the photo's meta data as PhotoMetadataModel
    /// - requires: an inspectable for each meta data item
    public func makeAttributedCaption(metadata: PhotoMetadataModel) {
        /// the main caption that once built becomes the label's text
        let caption = NSMutableAttributedString()
        
        /// initialized to false so newline character is NOT attached prior to first line
        /// after first line it is assigned true so newlines are attached prior to each line
        var newline = false
        
        if photoTitle {
            caption.appendAttributedString(formatCaptionTitle(title: metadata.photoTitle, newline))
            newline = true
        }
        if photoDescription {
            caption.appendAttributedString(formatCaptionDescription(description: metadata.photoDescription, newline))
            newline = true
        }
        
        if aperture {
            caption.appendAttributedString(formatCaptionAndInfo(caption: "aperture", info: metadata.cameraAperture, newline))
            newline = true
        }
        
        if exposure {
            caption.appendAttributedString(formatCaptionAndInfo(caption: "exposure", info: metadata.cameraExposure, newline))
            newline = true
        }
        
        if camera {
            caption.appendAttributedString(formatCaptionAndInfo(caption: "camera", info: metadata.cameraMake + "/" + metadata.cameraModel, newline))
            newline = true
        }

        if focalLength {
            caption.appendAttributedString(formatCaptionAndInfo(caption: "focal length", info: metadata.lensFocalLength, newline))
            newline = true
        }
        
        if pixelSize {
            let width = String(Int(metadata.imagePixelWidth))
            let height = String(Int(metadata.imagePixelHeight))
            
            caption.appendAttributedString(formatCaptionAndInfo(caption: "pixels", info: width + String(multiplicationSign) + height, newline))
            newline = true
        }
        
        if dateTaken {
            let dateTime = NSDate.parseString(metadata.photoDateTime, format: "yyyy:MM:dd HH:mm:ss")
        
            caption.appendAttributedString(formatCaptionAndInfo(caption: "taken", info: dateTime.toString("MMM d, yyyy 'at' h:mm a"), newline))
            newline = true
        }
        
        if gps {
            if !metadata.gpsLatitude.isEmpty && !metadata.gpsLatitude.isEmpty {
                caption.appendAttributedString(formatCaptionAndInfo(caption: "gps", info: metadata.gpsLatitude + ", " + metadata.gpsLongitude, newline))
            } else {
                caption.appendAttributedString(formatCaptionAndInfo(caption: "gps", info: "gps not available", newline))
            }
            newline = true
        }
        
        // done building set the text
        self.attributedText = caption
    }
    
    // MARK: Format Helpers
    
    /// format caption title
    /// - parameter title: string
    /// - parameter newline: boolean if true then add newline before text
    /// - returns: NSMutableAttributedString
    /// - requires: lineHeight from Inspectable
    private func formatCaptionTitle(title title: String, _ newline: Bool) -> NSMutableAttributedString {
        let captionTitle = NSMutableAttributedString(string: (newline ? "\r" : "") + title, style: UIFontTextStyleHeadline, lineHeight: lineHeight)
        return captionTitle
    }
    
    /// format caption description
    /// - parameter description: string
    /// - parameter newline: boolean if true then add newline before text
    /// - returns: NSMutableAttributedString
    /// - requires: lineHeight from Inspectable
    private func formatCaptionDescription(description description: String, _ newline: Bool) -> NSMutableAttributedString {
        let captionDescription = NSMutableAttributedString(string: (newline ? "\r" : "") + description, style: UIFontTextStyleCaption1, lineHeight: lineHeight)
        return captionDescription
    }

    /// format caption and info
    /// - parameter caption: string
    /// - parameter info: string
    /// - parameter newline: boolean if true then add newline before text
    /// - returns: NSMutableAttributedString
    /// - requires: lineHeight from Inspectable
    private func formatCaptionAndInfo(caption caption: String, info: String, _ newline: Bool) -> NSMutableAttributedString {
        
        let captionAndInfo = NSMutableAttributedString(string: (newline ? "\r" : "") + caption + ":", style: UIFontTextStyleCaption1, lineHeight: lineHeight)
        captionAndInfo.appendAttributedString(NSMutableAttributedString(string: " " + info, style: UIFontTextStyleSubheadline))
        
        return captionAndInfo
    }
    
    // MARK: Example data
    
    /// example data displayed by Interface Builder
    private func initMetadataForIBInspectable() {
        metadataForIBInspectable.imageType = "jpeg"
        
        metadataForIBInspectable.photoTitle = "Title From IPTC Object Name"
        metadataForIBInspectable.photoDescription = "This is the description that's contained in the IPTC Caption Abstract"
        metadataForIBInspectable.photoKeywords = ["cute","kitten","meme"]
        metadataForIBInspectable.photoDateTime = "2015:06:03 19:27:58"
        
        metadataForIBInspectable.cameraAperture = metadataForIBInspectable.fStopCharacter + "2.8"
        metadataForIBInspectable.cameraExposure = "1/250" + metadataForIBInspectable.exposureSecondsCode
        
        metadataForIBInspectable.imagePixelHeight = 765
        metadataForIBInspectable.imagePixelWidth = 1024
        
        metadataForIBInspectable.cameraMake = "Apple"
        metadataForIBInspectable.cameraModel = "iPhone 4"
        
        metadataForIBInspectable.lensFocalLength = "3.85" + metadataForIBInspectable.millimetreCode
        
        metadataForIBInspectable.gpsLatitude = "35.19867"
        metadataForIBInspectable.gpsLongitude = "-82.61684"
        metadataForIBInspectable.gpsLatitudeRef = "N"
        metadataForIBInspectable.gpsLongitudeRef = "W"
    }
    
}
