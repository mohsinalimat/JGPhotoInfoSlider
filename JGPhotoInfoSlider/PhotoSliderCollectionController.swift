//
//  PhotoSliderCollectionController.swift
//
//  Created by Jeff on 7/14/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class PhotoSliderCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let photoFlowLayout = PhotoSliderCollectionFlowLayout()
    
    private var photosData = PhotosDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assign my layout: PhotoSliderCollectionFlowLayout
        self.collectionView!.collectionViewLayout = photoFlowLayout
        
        posistionCollectionViewFrame()
        
        // set as default
        self.collectionView!.contentMode = .ScaleAspectFill
        
        // paging to keep photo centered after sliding
        self.collectionView!.pagingEnabled = true
        
        //  loadPhotoData() in extension
        if let photos = loadPhotoData() {
            if photos.count() > 0 {
                self.photosData = photos
            } else {
                exitFailLog("no photos were found")
            }
        }
        
    }
    
    /// set the y origin of the collection's view frame
    private func posistionCollectionViewFrame() {
        if self.collectionView!.frame.size.width > self.collectionView!.frame.size.height {
            // use the full height in landscape so pin to top
            self.collectionView!.frame.origin.y = 0
        } else {
            // drop frame's display position when there's extra real estate in portrait
            self.collectionView!.frame.origin.y = self.collectionView!.frame.midY - self.collectionView!.frame.midX
        }
    }
    
    // return the item's cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return self.collectionView!.frame.size
    }

    // handle rotation screen size changes
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        // keep currently visible photo the same after rotation
        // save the index before rotation
        if let lastIndexPath  = collectionView?.indexPathsForVisibleItems()[0]{
            
            // set new size and reclaculate the layout
            photoFlowLayout.itemSize = size
            photoFlowLayout.invalidateLayout()
            
            // animate during the rotation
            coordinator.animateAlongsideTransition({ (context) -> Void in
                UIView.animateWithDuration(0.20, delay: 0.0, options: .CurveEaseOut, animations: {
                    self.collectionView?.alpha = 0.0
                    }, completion: nil)
                },
                completion: { (context) -> Void in
                    
                    self.posistionCollectionViewFrame()
                    
                    // for some reason animation is required to be true here:
                    self.collectionView?.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: .Left, animated: true)
                    
                    // using delay here to cover scrolling which looks creepy
                    UIView.animateWithDuration(0.20, delay: 0.30, options: .CurveEaseOut, animations: {
                        self.collectionView?.alpha = 1.0
                        }, completion: nil)
                    
            })
            
        } else {
            // probably can never occur but skip animation if it does
            photoFlowLayout.itemSize = size
            photoFlowLayout.invalidateLayout()
        }
        
    }
    
    /// print message, function, file, line number then exit
    private func exitFailLog(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
        print("\(message):\r\(function) : \(file) Line:\(line)\r")
        exit(EXIT_FAILURE)
    }

    
}

extension PhotoSliderCollectionController {
    
    // return the number of photos
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosData.count()
    }
    
    // dequeue and load cells
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoSliderCollectionCell
        
        // pull the full image data from the PhotoDataSource model
        if let imageData = photosData.getPhotoDataByIndex(indexPath.row) {
            
            // break out the UIImage from the full imageData
            if let img = UIImage(data: imageData) {
                
                // load the image to the cell
                cell.displayPhoto(img)
            
                // break out the metadata from the full imageData using the PhotoMetadataModel
                let metadata = PhotoMetadataModel(cfMetaData: imageData)
                
                // load the metadata to to cell
                cell.loadMetadata(metadata)
            }
        }
        
        // return the PhotoSliderCollectionCell
        return cell
    }
    
}

extension PhotoSliderCollectionController {
    
    // add parallax effect
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // set the the parallax intensity level
        let parallaxVelocity: CGFloat = 150.0

        // preform parallax on the visible cells
        if let visibleCells = collectionView!.visibleCells() as? [PhotoSliderCollectionCell] {
            for parallaxCell in visibleCells {
                
                // calculate the parallax offset
                let xOffset = ((collectionView!.contentOffset.x - parallaxCell.originX) / parallaxCell.width) * parallaxVelocity
                
                // set the cell to the offset
                parallaxCell.offsetX(xOffset)
            }
        }
    }
    
}



