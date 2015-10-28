# JGPhotoInfoSlider

Photo slider with parallax that also displays photo metadata. Uses @IBDesignable for selecting and configuring the info display.

## Screen Example
<img src="https://raw.githubusercontent.com/ziligy/JGPhotoInfoSlider/master/JGPhotoInfoSlider.gif" alt="JGPhotoInfoSlider"/>

## Features
- photo slider with parallax
- displays photo metadata configured using @IBDesignable
- adjusts to use full device width
- any orientation while preserving original aspect
- built on UICollectionViewController
- component based

## Usage

### -> Set Images
- add your photos to SliderImages
- configure PhotoSliderCollectionData
- OR create your own PhotosDataSource

### -> Select Metadata
- select Metadata Caption Label in storyboard
- use attributes inspector to choose the desired metadata

## Metadata @IBInspectables
- photoTitle
- photoDescription
- aperture
- exposure
- camera
- focalLength
- pixelSize
- dateTaken
- keyWords
- gps

## Requirements
1. Xcode 7.1
2. iOS 9.0+
