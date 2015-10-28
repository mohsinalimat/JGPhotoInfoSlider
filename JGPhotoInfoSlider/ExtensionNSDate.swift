//
//  ExtensionNSDate.swift
//
//  Created by Jeff on 7/30/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import Foundation

// "MMM d, yyyy 'at' h:mm a" -- Oct 5, 2012 at 3:03 PM

extension NSDate {
    
    class func parseString(dateString: String, format: String = "yyyy-MM-dd HH:mm:ss") -> NSDate{
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(dateString)!
    }
    
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
}
