//
//  MFLBaseTextInputView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 03/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

@IBDesignable open class MFLBaseTextInputView : UIView {
    
    fileprivate var animationCompletionBlock : (() -> Void)?
    
    @IBInspectable var placeholder : String? = "Placeholder" {
        didSet {
            placeholderTextLayer.string = placeholder
        }
    }
    
    @IBInspectable public var error : String? = nil {
        didSet {
            set(error: error)
        }
    }
    
    public func resetToDefaultState() {
        placeholderTextLayer.foregroundColor = placeholderDefaultColor.cgColor
        errorLabel.text = nil
        separatorView.backgroundColor = separatorDefaultColor
        imageView.image = nil
    }
    
    // Placeholder
    @IBInspectable var placeholderDefaultColor = UIColor.mfl_green { didSet { placeholderTextLayer.foregroundColor = placeholderDefaultColor.cgColor } }
    @IBInspectable var placeholderErrorColor = UIColor.mfl_lollipop
    @IBInspectable var largePlaceholderFont = UIFont.systemFont(ofSize: 17.0)
    @IBInspectable var smallPlaceholderFont = UIFont.systemFont(ofSize: 13.0)
    
    fileprivate lazy var placeholderTextLayer : CATextLayer =  {
        let textLayer = CATextLayer()
        textLayer.string = self.placeholder
        textLayer.font = self.largePlaceholderFont.fontName as CFTypeRef?
        textLayer.fontSize = self.largePlaceholderFont.pointSize
        textLayer.foregroundColor = self.placeholderDefaultColor.cgColor
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.layer.addSublayer(textLayer)
        
        return textLayer
    }()
    
    // StackView
    fileprivate lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
    
        self.addSubview(stackView)
        
        stackView.spacing = self.imageView_leftPadding
        stackView.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        stackView.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        
        let views: [String : UIView] = ["stackView" : stackView, "separator" : self.separatorView]
        let metrics: [String : CGFloat] = ["topSpacing" : self.topSpacing]
        
        NSLayoutConstraint.constraints(withVisualFormat: "V:|-topSpacing-[stackView][separator]", options: [], metrics: metrics, views: views).activate()
        NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: [], metrics: nil, views: views).activate()
        
        stackView.addArrangedSubview(self.textInputContentView)
        stackView.addArrangedSubview(self.errorImageContentView)
        
        return stackView
    }()
    
    lazy var errorImageContentView : UIView = {
        
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.imageView)
        
        let views: [String : UIView] = ["imageView" : self.imageView]
        NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: [], metrics: nil, views: views).activate()
        self.imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
        
    }()
    
    lazy var textInputContentView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        view.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        
        return view
    }()
    
    // Image
    fileprivate lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = nil
        
        imageView.widthAnchor.constraint(equalToConstant: self.imageView_size.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.imageView_size.height).isActive = true
        
        return imageView
    }()
    
    // Separator
    @IBInspectable var separatorDefaultColor = UIColor.mfl_lightSlate
    @IBInspectable var separatorSuccessColor = UIColor.mfl_green
    @IBInspectable var separatorErrorColor = UIColor.mfl_lollipop
    
    lazy var separatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.separatorDefaultColor
        
        self.addSubview(view)
        
        let views: [String : UIView] = ["view" : view, "errorLabel" : self.errorLabel]
        let metrics = ["height" : self.separatorView_height, "padding" : self.errorLabel_topPadding]
        
        NSLayoutConstraint.constraints(withVisualFormat: "V:[view(height)]-padding-[errorLabel]", options: [], metrics: metrics, views: views).activate()
        NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: metrics, views: views).activate()
        
        
        return view
    }()
    
    // Error Label
    @IBInspectable var errorFont = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightSemibold)
    @IBInspectable var errorColor = UIColor.mfl_lollipop
    
    lazy var errorLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = self.errorFont
        label.textColor = self.errorColor
        
        self.addSubview(label)
        
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        
        let views = ["label" : label]
        let metrics = ["height" : self.errorLabel_height]
        
        NSLayoutConstraint.constraints(withVisualFormat: "V:[label(height)]|", options: [], metrics: metrics, views: views).activate()
        NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: views).activate()
        
        return label
    }()
    
    // Constants
    let animationsDuration                  = TimeInterval(0.1)
    fileprivate let placeholderLabelHeight  = CGFloat(25.0)
    fileprivate let topSpacing              = CGFloat(20.0)
    fileprivate let imageView_size          = CGSize(width: 24.0, height: 24.0)
    fileprivate let imageView_leftPadding   = CGFloat(10.0)
    fileprivate let separatorView_height    = CGFloat(1.0)
    fileprivate let errorLabel_topPadding   = CGFloat(4.0)
    fileprivate let errorLabel_height       = CGFloat(15.0)
    fileprivate let largePlaceholderBotSpacing = CGFloat(5.0)
    
    // Override
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if isAnimating { return }
        
        // Placeholder
        placeholderTextLayer.frame.size.width = bounds.width
        placeholderTextLayer.frame.size.height = placeholderLabelHeight
        placeholderTextLayer.fontSize = isLarge ? largePlaceholderFont.pointSize : smallPlaceholderFont.pointSize
        
        
        let largePlaceholderY = separatorView.y - largePlaceholderFont.pointSize - largePlaceholderBotSpacing
        placeholderTextLayer.position = CGPoint(x: 0.0, y: isLarge ? largePlaceholderY : 0.0)
        
        _ = stackView
    }
    
    // Helper
    fileprivate var isLarge = true
    fileprivate var isAnimating = false
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - CAAnimationDelegate
extension MFLBaseTextInputView : CAAnimationDelegate {
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        isAnimating = false
        isLarge = !isLarge
        placeholderTextLayer.fontSize = isLarge ? largePlaceholderFont.pointSize : smallPlaceholderFont.pointSize
        setNeedsLayout()
        layoutIfNeeded()
        animationCompletionBlock?()
    }
    
}

//MARK: - Helper 
extension MFLBaseTextInputView {
    
    func setPlaceholder(toSmall: Bool, animated: Bool, completion: (() -> Void)? = nil) {
        
        if toSmall == !isLarge {
            completion?()
            return
        }
        
        if !animated {
            isLarge = !toSmall
            setNeedsLayout()
            completion?()
            return
        }
        
        animationCompletionBlock = completion
        
        let startFontSize = toSmall ? largePlaceholderFont.pointSize : smallPlaceholderFont.pointSize
        let endFontSize = toSmall ? smallPlaceholderFont.pointSize : largePlaceholderFont.pointSize
        
        isAnimating = true
        
        let fontSizeAnimation = CABasicAnimation()
        fontSizeAnimation.fromValue = startFontSize
        fontSizeAnimation.toValue = endFontSize
        fontSizeAnimation.duration = animationsDuration
        fontSizeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        fontSizeAnimation.delegate = self   
        placeholderTextLayer.add(fontSizeAnimation, forKey: nil)
    }
    
    fileprivate func set(error: String?) {
        
        if mfl_nilOrEmpty(error) {
            placeholderTextLayer.foregroundColor = placeholderDefaultColor.cgColor
            errorLabel.text = nil
            separatorView.backgroundColor = separatorSuccessColor
            imageView.setImageTemplate(named: "success_mark_green", in: Bundle.subspecBundle(named: "Common"), color: placeholderDefaultColor)
        } else {
            placeholderTextLayer.foregroundColor = placeholderErrorColor.cgColor
            errorLabel.text = error!
            separatorView.backgroundColor = separatorErrorColor
            imageView.setImageTemplate(named: "fail_mark_red", in: Bundle.subspecBundle(named: "Common"), color: placeholderErrorColor)
        }
    }
    
}
