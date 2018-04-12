//
//  RoundedView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 09/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

@IBDesignable class BorderedView : UIView {
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = CGFloat(1.0) {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}

@IBDesignable class RoundedView : BorderedView {
    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.cornerRadius
    }
}

@IBDesignable class CircleView : BorderedView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = min(frame.width, frame.height) / 2
    }
}
