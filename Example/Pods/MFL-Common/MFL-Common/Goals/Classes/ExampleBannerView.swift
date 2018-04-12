//
//  ExampleBannerView.swift
//  MFLHalsa
//
//  Created by Jonathan Flintham on 17/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class ExampleBannerView: UIView {

    let preferredSize = CGSize(width: 66, height: 66)
    
    static let bannerInsetRatio: CGFloat = 0.45
    
    var style : Style? { didSet { setNeedsDisplay() } }
    
    init() {
        super.init(frame: CGRect(origin: CGPoint.zero, size: preferredSize))
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        
        let xInset = rect.width * ExampleBannerView.bannerInsetRatio
        let yInset = rect.height * ExampleBannerView.bannerInsetRatio
        
        let path = UIBezierPath()
        path.move(to: rect.origin)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - yInset))
        path.addLine(to: CGPoint(x: xInset, y: rect.minY))
        
        
        if let style = style {
            style.primary.setFill()
        } else {
            UIColor.mfl_lightBlue.setFill()
        }
        
        path.fill()
        
        guard let context = UIGraphicsGetCurrentContext() else { preconditionFailure() }
        context.saveGState()
        defer { context.restoreGState() }
        
        context.translateBy(x: 27, y: 3) // some magic numbers
        let angle = CGFloat.pi / 4.0
        context.rotate(by: angle)
        
        let textColor = style != nil ? style!.textColor4 : .white
        let text = NSAttributedString(string: NSLocalizedString("EXAMPLE", comment: ""),
                                      attributes: [NSForegroundColorAttributeName: textColor,
                                                   NSFontAttributeName: UIFont.systemFont(ofSize: 11, weight: UIFontWeightMedium)])
        text.draw(at: rect.origin)
    }
}
