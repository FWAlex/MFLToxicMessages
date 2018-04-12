//
//  PlayIcon.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 05/10/2017.
//

import Foundation

public class PlayIcon : UIView {
    
    public var color = UIColor.black { didSet { setNeedsDisplay() } }
    
    public init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    fileprivate func initialize() {
        isOpaque = false
        backgroundColor = .clear
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let circlePath = UIBezierPath(ovalIn: rect)
        
        UIColor.white.setFill()
        circlePath.fill()
        
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: 16.5, y: 14.5))
        trianglePath.addLine(to: CGPoint(x: rect.size.width - 9.5, y: rect.size.height / 2))
        trianglePath.addLine(to: CGPoint(x: 16.5, y: rect.size.height - 14.5))
        trianglePath.addLine(to: CGPoint(x: 16.5, y: 14.5))
        
        color.setFill()
        trianglePath.fill()
    }
}
