//
//  StepView.swift
//  MFLHalsa
//
//  Created by Jonathan Flintham on 07/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

private let animKey = "key"

protocol StepViewDelegate: class {
    func stepView(_ sender: StepView, shouldChangeState state: Bool) -> Bool
    func stepView(_ sender: StepView, didChangeState state: Bool)
}

@IBDesignable class StepView: UIView {
    
    weak var delegate: StepViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    fileprivate var number: Int = 1 {
        didSet {
            
        }
    }
    
    init(number: Int) {
        super.init(frame: CGRect.zero)
        self.number = number
        setUp()
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            backColor = backgroundColor
            super.backgroundColor = UIColor.clear
            
            setNeedsDisplay()
        }
    }
    
    func setUp() {
        
        self.layer.addSublayer(textLayer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
        
        super.backgroundColor = UIColor.clear
    }
    
    func didTap() {
        let shouldChange = delegate?.stepView(self, shouldChangeState: !isOn) ?? true
        if shouldChange {
            set(isOn: !isOn, animated: true)
        }
    }
    
    
    @IBInspectable var isOn = false
    
    func set(isOn: Bool, animated: Bool) {
        
        if isOn == self.isOn { return }
        
        self.isOn = isOn
        
        if animated {
            animate(on: isOn)
        } else {
            setNeedsDisplay()
        }
        
        delegate?.stepView(self, didChangeState: isOn)
    }
    
    
    var style : Style? {
        didSet {
            if let style = style {
                borderColor = style.textColor1
                offTextColor = style.primary
                backColor = style.textColor1
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0
    @IBInspectable var borderColor: UIColor = UIColor.mfl_greyishBrown
    @IBInspectable var fillColor: UIColor = UIColor.white
    @IBInspectable var offTextColor: UIColor = UIColor.mfl_green
    @IBInspectable var onTextColor: UIColor = UIColor.white
    @IBInspectable var backColor: UIColor? = UIColor.mfl_greyishBrown
    @IBInspectable var font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
    
    fileprivate var offFillLayer: CAShapeLayer?
    
    fileprivate lazy var textLayer: CATextLayer = {
        let textLayer = CATextLayer()
        textLayer.string = "\(self.number)"
        textLayer.font = self.font.fontName as CFTypeRef?
        textLayer.fontSize = self.font.pointSize
        textLayer.foregroundColor = self.offTextColor.cgColor
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = kCAAlignmentCenter
        
        return textLayer
    }()
    
    var boundsSize: CGFloat {
        return min(bounds.size.width, bounds.size.height)
    }
    
    var boundsCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        backColor?.setFill()
        pathForBackground.fill()
        
        if !isOn {
            drawOffFill()
            textLayer.foregroundColor = self.offTextColor.cgColor
        } else {
            offFillLayer?.removeFromSuperlayer()
            textLayer.foregroundColor = self.onTextColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLayer.frame.size.width = bounds.width
        textLayer.frame.size.height = font.lineHeight
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private var size: CGFloat {
        return min(bounds.size.width, bounds.size.height)
    }
    
    private func drawOffFill() {
        
        offFillLayer?.removeFromSuperlayer()
        
        offFillLayer = CAShapeLayer()
        offFillLayer?.frame = bounds
        offFillLayer?.path = Paths.forFill(size: boundsSize, center: boundsCenter, lineWidth: borderWidth).cgPath
        offFillLayer?.lineWidth = borderWidth
        offFillLayer?.fillColor = fillColor.cgColor
        offFillLayer?.strokeColor = borderColor.cgColor
        offFillLayer?.rasterizationScale = 2.0 * UIScreen.main.scale
        offFillLayer?.shouldRasterize = true
        
        layer.insertSublayer(offFillLayer!, below: textLayer)
    }
    
    private func animate(on: Bool) {
        
        let duration = 0.25
        
        if on {
            textLayer.foregroundColor = onTextColor.cgColor
        }
        
        let textScaleDown = Animations.fill(bounces: 1, amplitude: 0, reverse: true)
        textScaleDown.duration = duration
        textLayer.add(textScaleDown, forKey: nil)
        
        drawOffFill()
        let fill = Animations.fill(bounces: 1, amplitude: 0, reverse: on ? true : false)
        fill.duration = duration
        offFillLayer?.add(fill, forKey: animKey)
        
        let textScaleUp = Animations.fill(bounces: 1, amplitude: 0.18, reverse: false)
        textScaleUp.duration = duration
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (on ? duration : duration * 0.75)) {
            self.textLayer.add(textScaleUp, forKey: nil)
            if (!on) {
                self.textLayer.foregroundColor = self.offTextColor.cgColor
            }
        }
    }
    
    private var pathForBackground: UIBezierPath {
        return Paths.forFill(size: boundsSize, center: boundsCenter, lineWidth: 0.0)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let insets = UIEdgeInsets(top: -12, left: -12, bottom: -12, right: -12)
        
        let relativeFrame = self.bounds
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, insets)
        return hitFrame.contains(point)
    }
}

private class Paths {
    
    class func forFill(size: CGFloat, center: CGPoint, lineWidth: CGFloat = 1.0) -> UIBezierPath {
        
        let radius = (size / 2) - (lineWidth / 2)
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: 0.0,
                                endAngle: .pi * 2.0,
                                clockwise: true)
        path.lineWidth = lineWidth
        
        return path
    }
}
