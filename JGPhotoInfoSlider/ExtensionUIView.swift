//
//  ExtensionUIView.swift
//
//  Created by Jeff on 10/27/15.
//  Copyright © 2015 Jeff Greenberg. All rights reserved.
//

import UIKit

extension UIView
{
    
    /// UIView Extension
    ///
    /// recurse through all subview levels
    /// apply closure to each uiview
    ///
    /// ```
    /// self.view.enumerateSubviews { (view) -> () in
    ///    print(view)
    ///	}
    /// ```
    func enumerateSubviews(closure: (view: UIView) -> ()) {
        
        for view in subviews {
            if view.isKindOfClass(UIView) {
                view.enumerateSubviews(closure)
                closure(view: view)
            }
        }
    }
}
