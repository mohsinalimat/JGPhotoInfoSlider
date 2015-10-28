//
//  ExtensionNSData.swift
//
//  Created by Jeff on 8/1/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import Foundation

extension NSData {
    
    convenience init?(named name: String) {
        
        if let resourceUrl = NSBundle.mainBundle().URLForResource(name, withExtension: "") {
            self.init(contentsOfURL: resourceUrl)
        } else {
            self.init()
        }
        
    }
}