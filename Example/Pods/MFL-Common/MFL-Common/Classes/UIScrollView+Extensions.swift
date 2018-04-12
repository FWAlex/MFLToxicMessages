//
//  UIScrollView+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 09/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    var horizontalPage : Int {
        get {
            if frame.width == 0.0 { return 0 }
            return Int(round(contentOffset.x / frame.width))
        }
        
        set {
            contentOffset.x = width * CGFloat(newValue)
            delegate?.scrollViewDidScroll?(self)
        }
    }
    
    var horizontalScrollPercentage : CGFloat {
        
        get {
            if contentSize.width == 0 { return 0 }
            let contentWidth = contentSize.width - bounds.width
            guard contentWidth > 0 else { return 0 }
            
            return contentOffset.x / (contentSize.width - bounds.width)
        }
        
        set {
            contentOffset.x = (contentSize.width - bounds.width) * newValue
        }
    }
    
    
}

