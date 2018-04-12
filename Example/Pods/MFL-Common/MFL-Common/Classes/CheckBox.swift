//
//  CheckBox.swift
//  Float
//
//  Created by Alex Miculescu on 13/01/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

private let animKey = "key"

public protocol CheckBoxDelegate: class {
    func checkBox(_ sender: CheckBox, didChangeState state: Bool)
}

@IBDesignable public class CheckBox: UIView {

    public weak var delegate: CheckBoxDelegate?
    
    fileprivate var isAnimatingOff : Bool = false
    fileprivate var isAnimatingOn : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    override public var backgroundColor: UIColor? {
        didSet {
            backColor = backgroundColor
            super.backgroundColor = UIColor.clear
            
            setNeedsDisplay()
        }
    }
    
    func setUp() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
        
        super.backgroundColor = UIColor.clear
    }
    
    func didTap() {
        isOn = !isOn
    }
    
    
    @IBInspectable public var isOn : Bool {
        get { return _isOn }
        set {
            if _isOn == newValue { return }
            _isOn = newValue
            
            if _isOn {
                animateOn()
            } else {
                animateOff()
            }
            
            self.delegate?.checkBox(self, didChangeState: _isOn)
        }
    }
    
    fileprivate var _isOn = false
    
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var borderColor: UIColor = UIColor.black
    @IBInspectable var lineWidth: CGFloat = 3.0
    @IBInspectable var boxColor: UIColor = UIColor.blue
    @IBInspectable var boxTintColor: UIColor = UIColor.blue
    @IBInspectable var checkColor: UIColor = UIColor.red
    private var backColor: UIColor? = UIColor.white
    
    
    fileprivate var onBoxLayer: CAShapeLayer?
    fileprivate var checkMarkLayer: CAShapeLayer?
        
    
    var boundsSize: CGFloat {
        return min(bounds.size.width, bounds.size.height)
    }
    
    var boundsCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override public func draw(_ rect: CGRect) {
    
        super.draw(rect)
        
        checkMarkLayer?.removeFromSuperlayer()
        onBoxLayer?.removeFromSuperlayer()
        
        backColor?.setFill()
        pathForBox.fill()
        
        if isOn {
            drawOnBox()
            drawCheckMark()
        } else {
            drawBorder()
        }
    }
    
    func setOn(_ on: Bool, animated: Bool) {
        guard on != _isOn else { return }
        
        if animated { isOn = on }
        else {
            _isOn = on
            setNeedsDisplay()
        }
    }
    
    private var size: CGFloat {
        return min(bounds.size.width, bounds.size.height)
    }
    
    private func drawOnBox() {
        
        onBoxLayer?.removeFromSuperlayer()
        
        onBoxLayer = CAShapeLayer()
        onBoxLayer?.frame = bounds;
        onBoxLayer?.path = pathForBox.cgPath
        onBoxLayer?.lineWidth = lineWidth
        onBoxLayer?.fillColor = boxColor.cgColor
        onBoxLayer?.strokeColor = boxTintColor.cgColor
        onBoxLayer?.rasterizationScale = 2.0 * UIScreen.main.scale
        onBoxLayer?.shouldRasterize = true;
        
        layer.addSublayer(onBoxLayer!)
    }
    
    private func drawBorder() {
        
        borderColor.setStroke()
        let borderPath = Paths.forBox(size: boundsSize,
                                      center: boundsCenter,
                                      lineWidth: borderWidth)
        borderPath.stroke()
    }
    
    private func drawCheckMark() {
        
        checkMarkLayer?.removeFromSuperlayer()
        
        checkMarkLayer = CAShapeLayer()
        checkMarkLayer?.frame = bounds
        checkMarkLayer?.path = Paths.forCheckMark(size: boundsSize).cgPath
        checkMarkLayer?.strokeColor = checkColor.cgColor
        checkMarkLayer?.fillColor = UIColor.clear.cgColor
        checkMarkLayer?.lineWidth = lineWidth
        checkMarkLayer?.lineCap = kCALineCapRound
        checkMarkLayer?.lineJoin = kCALineJoinRound
        checkMarkLayer?.rasterizationScale = 2.0 * UIScreen.main.scale
        checkMarkLayer?.shouldRasterize = true
        
        layer.addSublayer(checkMarkLayer!)
    }
    
    private func animateOn() {
        
        drawOnBox()
        
        let wiggle = Animations.fill(bounces: 1, amplitude: 0.18, reverse: false)
        onBoxLayer?.add(wiggle, forKey: animKey)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + wiggle.duration / 5) {
            self.drawCheckMark()
            let stroke = Animations.stroke(reverse: false)
            stroke.duration = (wiggle.duration / 5) * 3
            self.checkMarkLayer?.add(stroke, forKey: animKey)
        }
    }
    
    private func animateOff() {
        
        isAnimatingOff = true
        
        drawOnBox()
        drawCheckMark()
        
        let wiggle = Animations.fill(bounces: 1, amplitude: 0.18, reverse: true)
        wiggle.duration = 0.3
        
        let stroke = Animations.stroke(reverse: true)
        stroke.duration = (wiggle.duration / 5) * 3
        stroke.delegate = self
        self.checkMarkLayer?.add(stroke, forKey: animKey)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + wiggle.duration / 5) {
            self.onBoxLayer?.add(wiggle, forKey: animKey)
        }
    }
    
    private var pathForBox: UIBezierPath {
        return Paths.forBox(size: boundsSize, center: boundsCenter)
    }
}

extension CheckBox : CAAnimationDelegate {
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard isAnimatingOff else { return }
        
        self.checkMarkLayer?.removeFromSuperlayer()
        isAnimatingOff = false

//        var anim = self.checkMarkLayer?.animation(forKey: animKey)
//        self.checkMarkLayer?.removeAnimation(forKey: animKey)
//        anim?.delegate = nil
    }
}

private class Paths {
    
    class func forBox(size: CGFloat, center: CGPoint, lineWidth: CGFloat = 1.0) -> UIBezierPath {
        
        let radius = (size / 2) - (lineWidth / 2)
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: 0.0,
                                endAngle: .pi * 2.0,
                                clockwise: true)
        path.lineWidth = lineWidth
        
        return path
    }
    
    class func forCheckMark(size: CGFloat) -> UIBezierPath {
        let checkMarkPath = UIBezierPath()
        
        checkMarkPath.move(to: CGPoint(x: size/3.2578, y: size/2))
        checkMarkPath.addLine(to: CGPoint(x: size/2.1618, y: size/1.57894))
        checkMarkPath.addLine(to: CGPoint(x: size/1.4405, y: size/2.6272))
        
        return checkMarkPath
    }
}

