//
//  PhotoMetadataModel.swift
//  ImageCaptionInfo
//
//  Created by Jeff on 6/28/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import UIKit
import CoreLocation
import Photos

public struct PhotoMetadataModel {
    
    // MARK: public variables
    var photoTitle = ""
    var photoDescription = ""
    var photoDateTime = ""
    var photoKeywords = []
    
    var imageType = ""
    var imagePixelHeight:CGFloat = 0.0
    var imagePixelWidth:CGFloat = 0.0
    var imageOrientation = UIImageOrientation.Up
    
    var cameraMake = ""
    var cameraModel = ""
    var cameraAperture = ""
    var cameraExposure = ""
    
    var lensFocalLength = ""
    
    var gpsLatitude = ""
    var gpsLongitude = ""
    var gpsLatitudeRef = ""
    var gpsLongitudeRef = ""
    
    // MARK: unicode constants
    let millimetreCode = "\u{339C}"
    let fStopCharacter = "\u{0192}"
    let exposureSecondsCode = "\u{0455}"
    
    
    // MARK: initialize
    init() {}
    
    // fetchPhotoMetadata
    init (cfMetaData: CFData) {
        
        // get the image type
        imageType = imageTypeFromImageData(cfMetaData)
        
        // get source refrence and create the properties index
        let selectedImageSourceRef = CGImageSourceCreateWithData(cfMetaData as CFData, nil) as CGImageSourceRef?
        let imagePropertiesDictionary = CGImageSourceCopyPropertiesAtIndex(selectedImageSourceRef!, 0, nil) as NSDictionary?
        
        //  for (key, value) inimagePropertiesDictionary { print("key: \(key) --> value: \(value)") }
        
        // set the pixel width & height
        if let pixelHeight = imagePropertiesDictionary?[kCGImagePropertyPixelHeight as String] as? CGFloat {
            imagePixelHeight = pixelHeight
        }
        if let pixelWidth = imagePropertiesDictionary?[kCGImagePropertyPixelWidth as String] as? CGFloat {
            imagePixelWidth = pixelWidth
        }
        
        // MARK: IPTC  - dictionary
        // create the dictionary for IPTC
        // extract: photoDescription, photoTitle, photoKeywords
        if let iptc = imagePropertiesDictionary?[kCGImagePropertyIPTCDictionary as String] as? NSDictionary {
            if let captionAbstract = iptc[kCGImagePropertyIPTCCaptionAbstract as String] as? String {
                photoDescription = captionAbstract
            }
            if let CObjectName = iptc[kCGImagePropertyIPTCObjectName as String] as? String {
                photoTitle = CObjectName
            }
            if let keywords = iptc[kCGImagePropertyIPTCKeywords as String] as? NSArray {
                photoKeywords = keywords
            }
            
        }
        
        // MARK: EXIF  - dictionary
        // create the dictionary for EXIF
        // extract: imageOrientation, cameraAperture, cameraExposure, lensFocalLength
        if let exif = imagePropertiesDictionary?[kCGImagePropertyExifDictionary as String] as? NSDictionary {
            if let FNumber = exif[kCGImagePropertyExifFNumber as String] as? Double {
                if FNumber < 10.0 {
                    cameraAperture = String(fStopCharacter) + String(format:"%.1f", FNumber)
                } else {
                    cameraAperture = String(fStopCharacter) + String(format:"%.0f", FNumber)
                }
            }
            if let ExposureTime = exif[kCGImagePropertyExifExposureTime as String] as? Double {
                cameraExposure = "1/" + String(format:"%.0f", 1/ExposureTime) + String(exposureSecondsCode)
            }
            if let FocalLength = exif[kCGImagePropertyExifFocalLength as String] as? Double {
                if FocalLength < 10.0 {
                    lensFocalLength = String(format:"%.2f", FocalLength)
                } else {
                    lensFocalLength = String(format:"%.0f", FocalLength)
                }
                lensFocalLength += String(millimetreCode)
            }
            if let Orientation = exif[kCGImagePropertyOrientation as String] as? Int {
                imageOrientation = exifOrientationToiOSOrientation(Orientation)
            }
        }
        
        // MARK: TIFF - dictionary
        // create the dictionary for TIFF
        // extract: photoDateTime, cameraMake, cameraModel
        if let tiff = imagePropertiesDictionary?[kCGImagePropertyTIFFDictionary as String] as? NSDictionary {
            if let dateTime = tiff[kCGImagePropertyTIFFDateTime as String] as? String {
                photoDateTime = dateTime
            }
            if let make = tiff[kCGImagePropertyTIFFMake as String] as? String {
                cameraMake = make
            }
            if let model = tiff[kCGImagePropertyTIFFModel as String] as? String {
                cameraModel = model
            }
        }
        
        // MARK: GPS - dictionary
        // create the dictionary for GPS
        // extract: gpsLatitudeRef, gpsLongitudeRef, gpsLatitude, gpsLongitude
        if let gps = imagePropertiesDictionary?[kCGImagePropertyGPSDictionary as String] as? NSDictionary {
            if let latitudeRef = gps[kCGImagePropertyGPSLatitudeRef as String] as? String {
                gpsLatitudeRef = latitudeRef
            }
            if let longitudeRef = gps[kCGImagePropertyGPSLongitudeRef as String] as? String {
                gpsLongitudeRef = longitudeRef
            }

            if let latitude = gps[kCGImagePropertyGPSLatitude as String] as? Double {
                if gpsLatitudeRef == "S" {
                    gpsLatitude = String(format:"%.5f", latitude * -1.0)
                } else {
                    gpsLatitude = String(format:"%.5f", latitude)
                }
            }
            if let longitude = gps[kCGImagePropertyGPSLongitude as String] as? Double {
                if gpsLongitudeRef == "W" {
                    gpsLongitude = String(format:"%.5f", longitude * -1.0)
                } else {
                    gpsLongitude = String(format:"%.5f", longitude)
                }
            }
        }
        
    }
    
    // MARK: helpers
    
    /// converts exif orienation numeric code to UIImageOrientation
    /// - parameter exifOrientation: Int
    /// - returns: UIImageOrientation
    private func exifOrientationToiOSOrientation(exifOrientation: Int) -> UIImageOrientation {
        var orientation = UIImageOrientation.Up
        switch (exifOrientation) {
        case 1:
            orientation = UIImageOrientation.Up
            break
        case 3:
            orientation = UIImageOrientation.Down
            break
        case 8:
            orientation = UIImageOrientation.Left
            break
        case 6:
            orientation = UIImageOrientation.Right
            break
        case 2:
            orientation = UIImageOrientation.UpMirrored
            break
        case 4:
            orientation = UIImageOrientation.DownMirrored
            break
        case 5:
            orientation = UIImageOrientation.LeftMirrored
            break
        case 7:
            orientation = UIImageOrientation.RightMirrored
            break
        default:
            break
        }
        return orientation
    }
    
    /// return the image type or empty
    /// - parameter data: NSData
    /// - returns: String
    private func imageTypeFromImageData(data: NSData) -> String {
        var value : Int16 = 0
        if data.length >= sizeof(Int16) {
            data.getBytes(&value, length:1)
    
            switch (value) {
            case 0xff:
                return "jpeg"
            case 0x89:
                return "png"
            case 0x47:
                return "gif"
            case 0x49:
                return "tiff"
            case 0x4D:
                return "tiff"
            default:
                return ""
            }
        }
        
        return ""
    }
    
    // MARK: DEBUG
    /// print the extracted metadata to console
    internal func displayMetadata() {
        print(imageType)
        
        print(photoTitle)
        print(photoDescription)
        print(photoKeywords)
        print(photoDateTime)
        
        print(cameraAperture)
        print(cameraExposure)
        
        print(imagePixelHeight)
        print(imagePixelWidth)
        
        print(cameraMake)
        print(cameraModel)
        
        print(lensFocalLength)
        
        print(gpsLatitude)
        print(gpsLongitude)
        print(gpsLatitudeRef)
        print(gpsLongitudeRef)
    }
    
}
