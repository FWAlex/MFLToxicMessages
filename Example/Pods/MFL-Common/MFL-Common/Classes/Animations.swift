//
//  Animations.swift
//  Float
//
//  Created by Alex Miculescu on 13/01/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class Animations {
    
    static var duration = 0.3
    
    class func fill(bounces: Int, amplitude: CGFloat, reverse: Bool) -> CAKeyframeAnimation {
        
        var values = [NSValue]()
        var keyTimes = [NSNumber]()
        
        if reverse {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1)))
        } else {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 0)))
        }
        
        keyTimes.append(0.0)
        
        for i in 1...bounces {
            let scale = i % 2 == 1 ? 1 + amplitude / CGFloat(i) : 1 - amplitude / CGFloat(i)
            let time = CGFloat(i) * (1.0 / CGFloat(bounces + 1))
            
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(scale, scale, scale)))
            keyTimes.append(time as NSNumber)
        }
        
        if reverse {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.0001, 0.0001, 0.0001)))
        } else {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1)))
        }
        
        keyTimes.append(1.0)
        
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.values = values
        animation.keyTimes = keyTimes
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        return animation
    }
    
    class func opacity(reverse: Bool) -> CABasicAnimation {
        
        return newAnimation(keyPath: "opacity", reverse: reverse)
    }
    
    class func stroke(reverse: Bool) -> CABasicAnimation {
        
        return newAnimation(keyPath: "strokeEnd", reverse: reverse)
    }
    
    private class func newAnimation(keyPath: String, reverse: Bool) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: keyPath)
        
        if reverse {
            animation.fromValue = 1.0
            animation.toValue = 0.0
        } else {
            animation.fromValue = 0.0
            animation.toValue = 1.0
        }
        
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        return animation
    }
}
