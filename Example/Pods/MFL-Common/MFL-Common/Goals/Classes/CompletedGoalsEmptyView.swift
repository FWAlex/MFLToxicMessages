//
//  CompletedGoalsEmptyView.swift
//  MFLHalsa
//
//  Created by Jonathan Flintham on 15/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class CompletedGoalsEmptyView: UIView {
    
    @IBOutlet fileprivate weak var infoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    fileprivate var gradientLayer : CAGradientLayer?
    
    var style : Style? { didSet { updateStyle() } }
    
    func updateStyle() {
        if let style = style {
            infoLabel.textColor = style.textColor4
            
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = CAGradientLayer()
            gradientLayer?.colors = style.gradient.map { $0.cgColor }
            gradientLayer?.frame = layer.bounds
            layer.insertSublayer(gradientLayer!, at: 0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        infoLabel.textColor = style != nil ? style!.textColor4 : .mfl_greyishBrown
        imageView.image = UIImage(named: "mountains_completed", bundle: .goals)
    }
    
    override func layoutSubviews() {
        gradientLayer?.frame = layer.bounds
    }
}
