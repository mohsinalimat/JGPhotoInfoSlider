//
//  ImageViewWithInfoCaption.swift
//
//  Created by Jeff on 7/22/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import UIKit

class ImageViewWithInfoCaption: UIImageView {
    
    // MARK: Storyboard required
    
    /// required constraint linked by 'CellTopConstraint' identifier in storyboard
    private var cellTopConstraint: NSLayoutConstraint!
    private let cellTopConstraintIdentifier = "CellTopConstraint"
    
    /// required constraint linked by 'infoButtonBottomConstraint' identifier in storyboard
    private var infoButtonBottomConstraint: NSLayoutConstraint!
    private let infoButtonBottomConstraintIdentifier = "InfoButtonBottomConstraint"
    
    /// required constraint linked by 'PhotoAspectConstraint' identifier in storyboard
    private var photoAspectConstraint: NSLayoutConstraint!
    private let photoAspectConstraintIdentifier = "PhotoAspectConstraint"
    
    // optional hand wired outlets can be substituted after commenting out same variable names above
    // @IBOutlet weak var cellTopConstraint: NSLayoutConstraint!
    // @IBOutlet weak var infoButtonBottomConstraint: NSLayoutConstraint!
    // @IBOutlet weak var photoAspectConstraint: NSLayoutConstraint!
    
    private var captionTextLabel: JGMetadataCaptionLabel!
    private var infoButton: JGTapButton!
    
    // MARK: Private vars

    /// y offset to center photo when height > screen
    private var boundsOffset: CGFloat!
    
    // MARK: Initialize
    
    /// set the image
    override var image: UIImage? {
        didSet {
            hideVisibleLabel()
            setPhotoAspect()
        }
    }
    
    func setPhotoAspect() {
        let ratio = image!.size.height / image!.size.width
        if photoAspectConstraint != nil {
            photoAspectConstraint.active = false
            photoAspectConstraint = self.heightAnchor.constraintLessThanOrEqualToAnchor(superview?.widthAnchor, multiplier: ratio)
            photoAspectConstraint.active = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wireupColaboratingObjects(self.superview!)
        self.userInteractionEnabled = true
        setupCaptionTextLabel()
        setupInfoButton()
        setupTapImageRecognizer()
    }
    
    /// look for JGTapButton & MetadataCaptionLabel
    /// assign them to infoButton & captionTextLabel
    /// exit-fail is they aren't found in the cell
    private func wireupColaboratingObjects(view: UIView) {
        
        for subview in view.subviews as [AnyObject] {
            if let JGTapButtonObject = subview as? JGTapButton {
                infoButton = JGTapButtonObject
            }
            if let MetadataCaptionLabelObject = subview as? JGMetadataCaptionLabel {
                captionTextLabel = MetadataCaptionLabelObject
            }
        }
        
        if infoButton == nil {exitFailLog("JGTapButton object not found failed to wire infoButton")}
        if captionTextLabel == nil {exitFailLog("MetadataCaptionLabel object not found failed to wire captionTextLabel")}
    
    }
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setRequiredContraints()
        adjustForBoundsVariance()
    }
    
    /// set the required constraints by searching storyboard for their identifiers
    /// will exit fail if they cannot be found
    func setRequiredContraints() {
        
        superview!.enumerateSubviews { (view) -> () in

            let searchConstraints = view.constraintsAffectingLayoutForAxis(UILayoutConstraintAxis.Vertical)
            
            for search in searchConstraints {
                
                switch search.identifier
                {
                case self.cellTopConstraintIdentifier?: self.cellTopConstraint = search
                case self.infoButtonBottomConstraintIdentifier?: self.infoButtonBottomConstraint = search
                case self.photoAspectConstraintIdentifier?: self.photoAspectConstraint = search
                default: break
                }
                
            }
            
        }
        
        if cellTopConstraint == nil {exitFailLog("CellTopConstraint contraiant identifier not found")}
        if infoButtonBottomConstraint == nil {exitFailLog("infoButtonBottomConstraint contraiant identifier not found")}
        if photoAspectConstraint == nil {exitFailLog("infoButtonBottomConstraint contraiant identifier not found")}
        
        // update the aspect for the current image
        setPhotoAspect()
    }
    

    // MARK: Functions
    
    /// set the caption label as attributed text
    /// - parameter metadata: the photo's metadata
    internal func setCaption(metadata: PhotoMetadataModel) {
        captionTextLabel.makeAttributedCaption(metadata)
    }
    
    /// direct tap gestures to fade out the caption label
    internal func handleTapToFadeOut(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .Ended {
            if captionTextLabel.alpha != 0.0 {
                captionFadeOut()
            }
        }
    }
    
    /// info button click will fade in caption label
    internal func infoButtonClicked(sender: UIButton!) {
        captionFadeIn()
    }
 
    /// set boundsOffset, adjust photo centering
    /// & position infoButton
    private func adjustForBoundsVariance() {
       
        hideVisibleLabel()
        
        if bounds.size.height > superview?.bounds.size.height {
            boundsOffset = (bounds.size.height - (superview?.bounds.size.height)!) / 2
            cellTopConstraint.constant = boundsOffset
        } else {
            boundsOffset = 0
            cellTopConstraint.constant = 0
        }
        
        infoButtonBottomConstraint.active = false
        if superview?.bounds.size.width > superview?.bounds.size.height {
            infoButtonBottomConstraint = infoButton.bottomAnchor.constraintEqualToAnchor(superview?.bottomAnchor, constant: -10)
        } else {
            infoButtonBottomConstraint = infoButton.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -10)
        }
        infoButtonBottomConstraint.active = true
        
        updateConstraints()
    }
    
    /// initialize info button defaults
    /// & touchUpInside click action
    private func setupInfoButton() {
        infoButton.bounds.size = CGSizeMake(30, 30)
        infoButton.image = UIImage(named: "infoi.png")!
        infoButton.raised = false
        infoButton.addTarget(self, action: "infoButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    
    }
    
    /// caption label defaults
    /// & set tap caption label gesture to fade out caption
    private func setupCaptionTextLabel() {
        captionTextLabel.userInteractionEnabled = true
        captionTextLabel.alpha = 0.0
        let tapLabelRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapToFadeOut:"))
        captionTextLabel.addGestureRecognizer(tapLabelRecognizer)
    }
    
    
    /// set tap image gesture to fade out caption
    private func setupTapImageRecognizer() {
        let tapImageRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapToFadeOut:"))
        self.addGestureRecognizer(tapImageRecognizer)
    }
    
    /// quickly hide the label 
    /// and re-display info button
    private func hideVisibleLabel() {
        captionTextLabel.alpha = 0.0
        infoButton.alpha = 1.0
    }
    
    
    /// fade in the caption label
    /// and fade out the info button
    private func captionFadeIn() {
        
        // wait for last minute to figure the label frame size & origin
        calculateCaptionLabelFrameAndOffset()
        
        // do the animation
        UIView.animateWithDuration(1.5, delay: 0.0, options: .CurveEaseOut, animations: {
            self.captionTextLabel.alpha = 1.0
            self.infoButton.alpha = 0.0
            }, completion: nil)
        
    }
    
    ///  calculate photo caption label frame size & origin
    /// - requires: boundsOffset
    private func calculateCaptionLabelFrameAndOffset() {
        
        let frameMarginOffset: CGFloat = 15 // add a little extra for the text frame
        
        let bottomYpos = self.frame.size.height + self.frame.origin.y
        let fixedWidth = self.frame.size.width
        
        let newSize = captionTextLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = captionTextLabel.frame
        
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height + frameMarginOffset)
        
        captionTextLabel.frame = newFrame
        captionTextLabel.frame.origin.y = bottomYpos - newSize.height - boundsOffset - frameMarginOffset
    }
    
    /// fade out the caption label
    /// and fade in the info button
    private func captionFadeOut() {
        
        UIView.animateWithDuration(0.75, delay: 0.0, options: .CurveEaseOut, animations: {
            self.captionTextLabel.alpha = 0.0
            self.infoButton.alpha = 1.0
            }, completion: nil)
    }
    
    // MARK: Debug
    
    /// print message, function, file, line number then exit
    private func exitFailLog(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
        print("\(message):\r\(function) : \(file) Line:\(line)\r")
        exit(EXIT_FAILURE)
    }
    
}
