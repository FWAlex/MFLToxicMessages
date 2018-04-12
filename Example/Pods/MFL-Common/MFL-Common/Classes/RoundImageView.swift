//
//  RoundImageView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import AlamofireImage

@IBDesignable class RoundImageView : UIImageView {
    
    @IBInspectable var isUsingPlaceholderLabel = false
    @IBInspectable var isUsingPlaceholderImage = true
    
    @IBInspectable var placeholderText : String? = "" { didSet { updatePlaceholder() } }
    @IBInspectable var placeholderTextColor : UIColor? = UIColor.white
    @IBInspectable var placeholderColor : UIColor? = UIColor.mfl_green
    
    fileprivate let fontPercentage = CGFloat(1.85)
    
    override var image: UIImage? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    
    fileprivate func initialize() {
        self.contentMode = .scaleAspectFill
        updatePlaceholder()
    }
    
    fileprivate lazy var backgroundColorLayer : CALayer = {
        
        let layer = CALayer()
        self.layer.addSublayer(layer)
        
        return layer
    }()
    
    fileprivate lazy var placeholderView : UIView = {
        let view = AvatarPlaceholderDrawableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        self.addSubview(view)
        
        let views = ["view" : view]
        NSLayoutConstraint.constraints(withVisualFormat: "V:|-(-1)-[view]-(-1)-|", options: [], metrics: nil, views: views).activate()
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-(-1)-[view]-(-1)-|", options: [], metrics: nil, views: views).activate()
        
        return view
    }()
    
    fileprivate lazy var placeholderLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        self.addSubview(label)
        
        let views = ["label" : label]
        NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: views).activate()
        NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: views).activate()
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = true
        
        placeholderLabel.font = UIFont.systemFont(ofSize: bounds.height / fontPercentage, weight: UIFontWeightMedium)
        
        let newCornerRadius = min(frame.size.width, frame.size.height) / 2
        if !(layer.cornerRadius == newCornerRadius) {
            layer.cornerRadius = newCornerRadius
        }
        
        backgroundColorLayer.frame = self.bounds
        updatePlaceholder()
    }
    
    fileprivate func updatePlaceholder() {
        backgroundColorLayer.backgroundColor = self.image != nil ? UIColor.clear.cgColor : placeholderColor?.cgColor
        
        placeholderLabel.isHidden = (self.image != nil) || !isUsingPlaceholderLabel || isUsingPlaceholderImage
        
        if !placeholderLabel.isHidden {
            placeholderLabel.text = placeholderText
            placeholderLabel.textColor = placeholderTextColor
            placeholderLabel.font = UIFont.systemFont(ofSize: bounds.height / fontPercentage, weight: UIFontWeightMedium)
        }
        
        placeholderView.isHidden = (self.image != nil) || isUsingPlaceholderLabel || !isUsingPlaceholderImage
    }
    
    func setPlaceholderAsFirstLetter(of placeholderString: String?) {
        
        if let firstLetter = placeholderString?.characters.first {
            placeholderText = "\(firstLetter)"
        }
        
    }
}

