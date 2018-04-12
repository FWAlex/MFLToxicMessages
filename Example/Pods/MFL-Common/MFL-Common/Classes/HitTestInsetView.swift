//
//  HitTestInsetView.swift
//  MFLHalsa
//
//  Created by Jonathan Flintham on 09/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class HitTestInsetsView: UIView {
    
    var hitTestInsets = UIEdgeInsets.zero
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let relativeFrame = self.bounds
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestInsets)
        return hitFrame.contains(point)
    }
}
