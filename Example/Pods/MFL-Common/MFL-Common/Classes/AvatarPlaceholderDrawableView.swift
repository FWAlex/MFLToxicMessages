//
//  AvatarPlaceholderDrawableView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 25/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

@IBDesignable class AvatarPlaceholderDrawableView: UIView {
    
    @IBInspectable var color = UIColor.white

    override func draw(_ rect: CGRect) {
       
        let frame = rect
        let context = UIGraphicsGetCurrentContext()!
        
        let strokeColor = color
        let fillColor = color
        
        let group2: CGRect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
        
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        let clip2Path = UIBezierPath()
        clip2Path.move(to: CGPoint(x: group2.minX + 0.50000 * group2.width, y: group2.minY + 1.00000 * group2.height))
        clip2Path.addCurve(to: CGPoint(x: group2.minX + 1.00000 * group2.width, y: group2.minY + 0.50000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.77614 * group2.width, y: group2.minY + 1.00000 * group2.height), controlPoint2: CGPoint(x: group2.minX + 1.00000 * group2.width, y: group2.minY + 0.77614 * group2.height))
        clip2Path.addCurve(to: CGPoint(x: group2.minX + 0.50000 * group2.width, y: group2.minY + 0.00000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 1.00000 * group2.width, y: group2.minY + 0.22386 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.77614 * group2.width, y: group2.minY + 0.00000 * group2.height))
        clip2Path.addCurve(to: CGPoint(x: group2.minX + 0.00000 * group2.width, y: group2.minY + 0.50000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.22386 * group2.width, y: group2.minY + 0.00000 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.00000 * group2.width, y: group2.minY + 0.22386 * group2.height))
        clip2Path.addCurve(to: CGPoint(x: group2.minX + 0.50000 * group2.width, y: group2.minY + 1.00000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.00000 * group2.width, y: group2.minY + 0.77614 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.22386 * group2.width, y: group2.minY + 1.00000 * group2.height))
        clip2Path.close()
        clip2Path.usesEvenOddFillRule = true
        clip2Path.addClip()
        
        
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        let clipPath = UIBezierPath()
        clipPath.move(to: CGPoint(x: group2.minX + 0.50000 * group2.width, y: group2.minY + 1.00000 * group2.height))
        clipPath.addCurve(to: CGPoint(x: group2.minX + 1.00000 * group2.width, y: group2.minY + 0.50000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.77614 * group2.width, y: group2.minY + 1.00000 * group2.height), controlPoint2: CGPoint(x: group2.minX + 1.00000 * group2.width, y: group2.minY + 0.77614 * group2.height))
        clipPath.addCurve(to: CGPoint(x: group2.minX + 0.50000 * group2.width, y: group2.minY + 0.00000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 1.00000 * group2.width, y: group2.minY + 0.22386 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.77614 * group2.width, y: group2.minY + 0.00000 * group2.height))
        clipPath.addCurve(to: CGPoint(x: group2.minX + 0.00000 * group2.width, y: group2.minY + 0.50000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.22386 * group2.width, y: group2.minY + 0.00000 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.00000 * group2.width, y: group2.minY + 0.22386 * group2.height))
        clipPath.addCurve(to: CGPoint(x: group2.minX + 0.50000 * group2.width, y: group2.minY + 1.00000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.00000 * group2.width, y: group2.minY + 0.77614 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.22386 * group2.width, y: group2.minY + 1.00000 * group2.height))
        clipPath.close()
        clipPath.usesEvenOddFillRule = true
        clipPath.addClip()
        
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: group2.minX + 0.50000 * group2.width, y: group2.minY + 1.00000 * group2.height))
        bezierPath.addCurve(to: CGPoint(x: group2.minX + 1.00000 * group2.width, y: group2.minY + 0.50000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.77614 * group2.width, y: group2.minY + 1.00000 * group2.height), controlPoint2: CGPoint(x: group2.minX + 1.00000 * group2.width, y: group2.minY + 0.77614 * group2.height))
        bezierPath.addCurve(to: CGPoint(x: group2.minX + 0.50000 * group2.width, y: group2.minY + 0.00000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 1.00000 * group2.width, y: group2.minY + 0.22386 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.77614 * group2.width, y: group2.minY + 0.00000 * group2.height))
        bezierPath.addCurve(to: CGPoint(x: group2.minX + 0.00000 * group2.width, y: group2.minY + 0.50000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.22386 * group2.width, y: group2.minY + 0.00000 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.00000 * group2.width, y: group2.minY + 0.22386 * group2.height))
        bezierPath.addCurve(to: CGPoint(x: group2.minX + 0.50000 * group2.width, y: group2.minY + 1.00000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.00000 * group2.width, y: group2.minY + 0.77614 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.22386 * group2.width, y: group2.minY + 1.00000 * group2.height))
        bezierPath.close()
        strokeColor.setStroke()
        bezierPath.lineWidth = 4//2
        bezierPath.stroke()
        
        
        context.endTransparencyLayer()
        context.restoreGState()
        
        
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: group2.minX + 0.41540 * group2.width, y: group2.minY + 0.70822 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.15037 * group2.width, y: group2.minY + 0.79000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.41540 * group2.width, y: group2.minY + 0.74696 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.22404 * group2.width, y: group2.minY + 0.71468 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.13104 * group2.width, y: group2.minY + 0.82372 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.14228 * group2.width, y: group2.minY + 0.79827 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.13597 * group2.width, y: group2.minY + 0.81018 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.30691 * group2.width, y: group2.minY + 0.95574 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.12886 * group2.width, y: group2.minY + 0.82972 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.21039 * group2.width, y: group2.minY + 0.91861 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.50000 * group2.width, y: group2.minY + 1.00000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.40087 * group2.width, y: group2.minY + 0.99189 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.50000 * group2.width, y: group2.minY + 1.00000 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.69365 * group2.width, y: group2.minY + 0.95574 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.50000 * group2.width, y: group2.minY + 1.00000 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.59559 * group2.width, y: group2.minY + 0.99459 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.87001 * group2.width, y: group2.minY + 0.82508 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.78548 * group2.width, y: group2.minY + 0.91936 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.87176 * group2.width, y: group2.minY + 0.83002 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.85019 * group2.width, y: group2.minY + 0.79000 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.86502 * group2.width, y: group2.minY + 0.81098 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.85855 * group2.width, y: group2.minY + 0.79855 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.60483 * group2.width, y: group2.minY + 0.70822 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.77653 * group2.width, y: group2.minY + 0.71468 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.60483 * group2.width, y: group2.minY + 0.74696 * group2.height))
        bezier3Path.addLine(to: CGPoint(x: group2.minX + 0.60483 * group2.width, y: group2.minY + 0.63938 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.64272 * group2.width, y: group2.minY + 0.53610 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.61746 * group2.width, y: group2.minY + 0.63938 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.64272 * group2.width, y: group2.minY + 0.54901 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.66797 * group2.width, y: group2.minY + 0.41990 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.65552 * group2.width, y: group2.minY + 0.53610 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.69323 * group2.width, y: group2.minY + 0.41990 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.50380 * group2.width, y: group2.minY + 0.18750 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.68692 * group2.width, y: group2.minY + 0.23914 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.59236 * group2.width, y: group2.minY + 0.18750 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.35226 * group2.width, y: group2.minY + 0.41990 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.41524 * group2.width, y: group2.minY + 0.18750 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.32700 * group2.width, y: group2.minY + 0.23914 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.36488 * group2.width, y: group2.minY + 0.53610 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.32700 * group2.width, y: group2.minY + 0.41990 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.35280 * group2.width, y: group2.minY + 0.53610 * group2.height))
        bezier3Path.addCurve(to: CGPoint(x: group2.minX + 0.41540 * group2.width, y: group2.minY + 0.63938 * group2.height), controlPoint1: CGPoint(x: group2.minX + 0.36488 * group2.width, y: group2.minY + 0.54901 * group2.height), controlPoint2: CGPoint(x: group2.minX + 0.40277 * group2.width, y: group2.minY + 0.63938 * group2.height))
        bezier3Path.addLine(to: CGPoint(x: group2.minX + 0.41540 * group2.width, y: group2.minY + 0.70822 * group2.height))
        bezier3Path.close()
        bezier3Path.usesEvenOddFillRule = true
        fillColor.setFill()
        bezier3Path.fill()
        
        
        context.endTransparencyLayer()
        context.restoreGState()
    }

}
