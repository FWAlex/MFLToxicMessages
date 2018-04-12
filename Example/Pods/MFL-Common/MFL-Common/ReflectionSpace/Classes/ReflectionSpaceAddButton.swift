//
//  ReflectionSpaceAddButton.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 05/02/2018.
//

import UIKit

class ReflectionSpaceAddButton : MFLView {
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var plusView: ReflectionSpacePlusView!
    
    typealias ReflectionSpaceAddButtonAction = () -> Void
    var action : ReflectionSpaceAddButtonAction?
    var style : Style? { didSet { updateStyle() } }
    
    override func initialize(bundle: Bundle?) {
        super.initialize(bundle: .reflectionSpace)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ReflectionSpaceAddButton.didTapAdd(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapAdd(_ sender: UITapGestureRecognizer) {
        action?()
    }
    
    private func updateStyle() {
        label.textColor = style?.textColor4
        plusView.plusColor = style?.textColor4.withAlphaComponent(0.8)
    }
}

class ReflectionSpacePlusView : UIView {
    
    private let lineWidth = CGFloat(10.0)
    private lazy var padding : CGFloat = { return self.lineWidth / 2 }()
    
    var plusColor : UIColor? = UIColor.white { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath()
        
        // Draw horizontal line
        path.move(to: CGPoint(x: padding, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width - padding, y: rect.height / 2))
        path.close()
        
        // Draw vertical line
        path.move(to: CGPoint(x: rect.width / 2, y: padding))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height - padding))
        path.close()
        
        path.lineJoinStyle = .round
        path.lineWidth = lineWidth
        plusColor?.setStroke()
        path.stroke()
    }
}

