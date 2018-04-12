//
//  MFLRoundedCell.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 05/05/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

enum RoundedCellCorners {
    case all, top, bottom, none
}

class MFLRoundedCell: UITableViewCell {

    open var cornerRadius = CGFloat(0.0) {
        didSet {
            updateCornerMask()
            updateBorder()
        }
    }
    
    open var roundedCorners = RoundedCellCorners.none {
        didSet {
            updateCornerMask()
            updateBorder()
        }
    }
    
    open var shouldAlwaysShowSeparator = false
    open var separatorColor = UIColor.mfl_lightSlate { didSet { updateSeparator() } }
    open var separatorWidth = CGFloat(0.5) { didSet { updateSeparator() } }
    
    open var borderInset = UIEdgeInsets.zero { didSet { updateCornerMask() } }
    open var borderColor = UIColor.mfl_lightSlate { didSet { updateBorder() } }
    open var borderWidth = CGFloat(1.0) { didSet { updateBorder() } }
    
    fileprivate var borderLayer : CAShapeLayer?
    fileprivate var separatorLayer : CAShapeLayer?
    
    fileprivate var lastBounds = CGRect.zero
    
    fileprivate func updateCornerMask() {
        
        var corners: UIRectCorner
        
        switch roundedCorners {
        case .all: corners = .allCorners
        case .top: corners = [.topLeft, .topRight]
        case .bottom: corners = [.bottomLeft, .bottomRight]
        case .none:
            layer.mask = nil
            return
        }
        
        
        let path = UIBezierPath(roundedRect: UIEdgeInsetsInsetRect(bounds, borderInset),
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        layer.mask = maskLayer
    }
    
    fileprivate func updateBorder() {
        
        borderLayer?.removeFromSuperlayer()
        borderLayer = roundedCorners.borderLayer(for: layer, cornerRadius: cornerRadius, color: borderColor, width: borderWidth)
        layer.insertSublayer(borderLayer!, at: 0)
    }
    
    fileprivate func updateSeparator() {
        
        if !shouldAlwaysShowSeparator && ( roundedCorners == .all || roundedCorners == .bottom ) {
            return
        }
        
        separatorLayer?.removeFromSuperlayer()
        
        let maxX = layer.bounds.size.width
        let maxY = layer.bounds.size.height
        let drawWidth = separatorWidth / 2
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: maxY - drawWidth))
        path.addLine(to: CGPoint(x: maxX, y:maxY - drawWidth))
        
        separatorLayer = CAShapeLayer()
        separatorLayer?.path = path.cgPath
        separatorLayer?.fillColor = UIColor.clear.cgColor
        separatorLayer?.strokeColor = separatorColor.cgColor
        
        
        
        separatorLayer?.opacity = 1.0;
        separatorLayer?.lineWidth = separatorWidth
        
        layer.insertSublayer(separatorLayer!, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let mask = layer.mask,
            !(mask.frame.size.width == bounds.width) ||
                !(mask.frame.size.height == bounds.height) {
            
            updateCornerMask()
        }
        
        if lastBounds != layer.bounds {
            lastBounds = layer.bounds
            updateBorder()
            updateSeparator()
        }
    }
}

fileprivate extension RoundedCellCorners {
    
    func borderLayer(for layer: CALayer, cornerRadius: CGFloat, color: UIColor, width: CGFloat) -> CAShapeLayer {
        
        var path: UIBezierPath
        
        let maxX = layer.bounds.size.width
        let maxY = layer.bounds.size.height
        let drawWidth = width / 2
        
        switch self {
        
        case .top:
            path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0 + drawWidth, y: maxY))
            path.addLine(to: CGPoint(x: 0.0 + drawWidth, y: 0.0 + cornerRadius + drawWidth))
            path.addArc(withCenter: CGPoint(x: cornerRadius + drawWidth, y: cornerRadius + drawWidth), radius: cornerRadius, startAngle: .pi, endAngle: .pi_270, clockwise: true)
            path.addLine(to: CGPoint(x: maxX - cornerRadius - drawWidth , y: 0.0 + drawWidth))
            path.addArc(withCenter: CGPoint(x: maxX - cornerRadius - drawWidth, y: cornerRadius + drawWidth), radius: cornerRadius, startAngle: .pi_270, endAngle: 0, clockwise: true)
            path.addLine(to: CGPoint(x: maxX - drawWidth , y: maxY))
        
        case .bottom:
            path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0 + drawWidth, y: 0.0))
            path.addLine(to: CGPoint(x: 0.0 + drawWidth, y: maxY - cornerRadius - drawWidth))
            path.addArc(withCenter: CGPoint(x: cornerRadius + drawWidth, y: maxY - cornerRadius - drawWidth), radius: cornerRadius, startAngle: .pi, endAngle: .pi_90, clockwise: false)
            path.addLine(to: CGPoint(x: maxX - cornerRadius - drawWidth , y: maxY - drawWidth))
            path.addArc(withCenter: CGPoint(x: maxX - cornerRadius - drawWidth, y: maxY - cornerRadius - drawWidth), radius: cornerRadius, startAngle: .pi_90, endAngle: 0, clockwise: false)
            path.addLine(to: CGPoint(x: maxX -  drawWidth , y: 0.0))
            
        case .none:
            path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0 + drawWidth, y: 0.0))
            path.addLine(to: CGPoint(x: 0.0 + drawWidth, y: maxY))
            path.move(to: CGPoint(x: maxX - drawWidth, y: 0.0))
            path.addLine(to: CGPoint(x: maxX - drawWidth, y: maxY))
            
        case .all:
            let rect = CGRect(x: 0.0 + drawWidth, y: 0.0 + drawWidth, width: maxX - 2 * drawWidth, height: maxY - 2 * drawWidth)
            path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        }
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        borderLayer.opacity = 1.0;
        borderLayer.lineWidth = width
        
        return borderLayer
    }
}


