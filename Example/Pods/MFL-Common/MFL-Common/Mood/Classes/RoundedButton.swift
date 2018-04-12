//
//  RoundedButton.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 27/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import Foundation
import Stripe

import UIKit
import Foundation
import Stripe

@IBDesignable public class RoundedButton : MFLButton {
    
    var intrinsicContentHeight = CGFloat(49)
    var intrinsicTitlePadding = CGFloat(40)
    
    @IBInspectable var usesCustomCornerRadius = false
    @IBInspectable var borderWidth = CGFloat(2.0)
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet {
            layer.borderColor = self.borderColor.cgColor
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius : CGFloat = 0.0 {
        didSet {
            usesCustomCornerRadius = true
            setNeedsLayout()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = usesCustomCornerRadius ? cornerRadius : height / 2
    }
    
    override public var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if !mfl_nilOrEmpty(titleLabel?.text) {
            contentSize.width += intrinsicTitlePadding
        }
        contentSize.height = intrinsicContentHeight
        return contentSize
    }
}

