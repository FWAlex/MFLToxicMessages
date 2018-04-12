//
//  MFLTextView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 03/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

@objc public protocol MFLTextViewDelegate : class {
    @objc optional func mflTextViewEditingDidBegin(_ sender: MFLTextView)
    @objc optional func mflTextViewEditingChanged(_ sender: MFLTextView)
    @objc optional func mflTextViewEditingDidEnd(_ sender: MFLTextView)
    @objc optional func mflTextView(_ sender: MFLTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
}

open class MFLTextView : MFLBaseTextInputView {
    
    var delegate : MFLTextViewDelegate?
    var maxExpansionHeight = CGFloat(150)
    
    /**
     *  The maximum number of characters the textView's text property can have. The default is 0.
     *  If set to a value greater than 0 the textView will not allow the user to type more characters,
     *  and the error label will be used to display the remaining number of characters.
     */
    var maxCharCount = 0 {
        didSet {
            updateCharCount()
        }
    }
    fileprivate var shouldLimitCharCount : Bool { return maxCharCount != 0 }
    
    @IBInspectable var textViewTintColor = UIColor.mfl_green {
        didSet { textView.tintColor = textViewTintColor }
    }
    @IBInspectable var textColor = UIColor.mfl_greyishBrown
    @IBInspectable var textFont = UIFont.systemFont(ofSize: 17.0)
    
    fileprivate var textViewHeightConstraint : NSLayoutConstraint!
    fileprivate var textViewInitialHeight = CGFloat(36.5)
    
    @IBInspectable var text : String? {
        get { return textView.text }
        set {
            setPlaceholder(toSmall: !mfl_nilOrEmpty(newValue), animated: false)
            textView.text = newValue
        }
    }
    
    lazy var textView : UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .sentences
        textView.textColor = self.textColor
        textView.font = self.textFont
        textView.isScrollEnabled = false
        
        self.textInputContentView.addSubview(textView)
        
        let views = ["textView" : textView]
        
        self.textViewHeightConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.textViewInitialHeight)
        self.textViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.constraints(withVisualFormat: "V:|[textView]|", options: [], metrics: nil, views: views).activate()
        NSLayoutConstraint.constraints(withVisualFormat: "H:|[textView]|", options: [], metrics: nil, views: views).activate()
        
        return textView
    }()
    
    override open func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        _ = textView
    }
}

extension MFLTextView : UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if mfl_nilOrEmpty(textView.text) {
            setPlaceholder(toSmall: true, animated: true)
        }
        
        delegate?.mflTextViewEditingDidBegin?(self)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.mflTextViewEditingDidEnd?(self)
        
        if mfl_nilOrEmpty(textView.text) {
            setPlaceholder(toSmall: false, animated: true)
        }
        
        textView.resignFirstResponder()
        textView.layoutIfNeeded()
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        
        let size = textView.sizeThatFits(CGSize(width: textView.width, height: CGFloat.infinity))
        
        if size.height < maxExpansionHeight {
            textViewHeightConstraint.constant = size.height
            textView.isScrollEnabled = false
        } else {
            textView.isScrollEnabled = true
        }
        
        updateCharCount()
        
        delegate?.mflTextViewEditingChanged?(self)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if let delegateValue = delegate?.mflTextView?(self, shouldChangeTextIn: range, replacementText: text) { return delegateValue }
        guard shouldLimitCharCount else { return true }
        if textView.text.length == maxCharCount && (range.length < text.length) { return false }
        
        let shouldChange = textView.text.length + (text.length - range.length) <= maxCharCount
        
        if !shouldChange {
            let nsText = textView.text as NSString
            let newText = nsText.replacingCharacters(in: range, with: text)
            textView.text = newText.substring(to: newText.index(newText.startIndex, offsetBy: maxCharCount))
            
            // Force call textViewDidChange.
            textViewDidChange(textView)
        }
        
        return shouldChange
    }
}

//MARK: - Helper
fileprivate extension MFLTextView {
    
    func updateCharCount() {
    
        if shouldLimitCharCount {
            let charCount = max(0, maxCharCount - textView.text.length)
            errorLabel.textColor = charCount == 0 ? errorColor : textColor
            separatorView.backgroundColor = errorLabel.textColor
            errorLabel.text = "\(charCount)"
        
        } else {
            errorLabel.textColor = errorColor
            error = error
        }
    }
    
}
