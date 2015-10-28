//
//  PhotoSliderCollectionFlowLayout.swift
//
//  Created by Jeff on 8/1/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import UIKit

class PhotoSliderCollectionFlowLayout: UICollectionViewFlowLayout {
    
    private var layoutInfo: [NSIndexPath:UICollectionViewLayoutAttributes] = [NSIndexPath:UICollectionViewLayoutAttributes]()

    private func setup() {
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareLayout() {
        layoutInfo = [NSIndexPath:UICollectionViewLayoutAttributes]()
        for var i = 0; i < self.collectionView?.numberOfItemsInSection(0); i++ {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            itemAttributes.frame = frameForItemAtIndexPath(indexPath)
            layoutInfo[indexPath] = itemAttributes
        }
    }

    private func frameForItemAtIndexPath(indexPath: NSIndexPath) -> CGRect {

        let xPos = CGFloat(indexPath.row) * self.collectionView!.frame.width
        
        return CGRectMake(xPos, 0, self.collectionView!.frame.width, self.collectionView!.frame.height)
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> (UICollectionViewLayoutAttributes!) {
        return layoutInfo[indexPath]
    }
           
}