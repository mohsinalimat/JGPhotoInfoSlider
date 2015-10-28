//
//  ExtensionNSMutableAttributedString.swift
//
//  Created by Jeff on 7/27/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import UIKit

public extension NSMutableAttributedString {
    
    convenience init(string str: String,  style: String, lineHeight: CGFloat = 0) {
        
        self.init(string: str)
        
        if lineHeight == 0 {
            self.setAttributes([NSFontAttributeName : UIFont.preferredFontForTextStyle(style)], range: NSMakeRange(0, self.length))
        } else {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight;
            paragraphStyle.maximumLineHeight = lineHeight;
            
            self.setAttributes([NSFontAttributeName : UIFont.preferredFontForTextStyle(style), NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, self.length))
        }
        
    }
}

