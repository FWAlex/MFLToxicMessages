//
//  Foo.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 03/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

public protocol MFLTextFieldViewDelegate : class {
    func textFieldViewEditingDidBegin(_ sender: MFLTextFieldView)
    func textFieldViewEditingChanged(_ sender: MFLTextFieldView)
    func textFieldViewEditingDidEnd(_ sender: MFLTextFieldView)
    func textFieldViewEditingDidEndOnExit(_ sender: MFLTextFieldView)
}

open class MFLTextFieldView : MFLBaseTextInputView {
    
    public var delegate : MFLTextFieldViewDelegate?
    
    @IBInspectable var textColor = UIColor.mfl_greyishBrown
    @IBInspectable var textFont = UIFont.systemFont(ofSize: 17.0)
    
    @IBInspectable public var text : String? {
        get { return textField.text }
        set {
            setPlaceholder(toSmall: !mfl_nilOrEmpty(newValue), animated: false)
            textField.text = newValue
        }
    }
    
    @IBInspectable var isSecure : Bool {
        get { return textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }
    
    var returnKeyType : UIReturnKeyType {
        get { return textField.returnKeyType }
        set { textField.returnKeyType = newValue }
    }
    
    public lazy var textField : UITextField = {
        let textField = UITextField()
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textColor = self.textColor
        textField.font = self.textFont
        textField.addTarget(self, action: #selector(self.editingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(self.editingDidEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(self.editingChanged), for: .editingChanged)
        textField.addTarget(self, action: #selector(self.editingDidEndOnExit), for: .editingDidEndOnExit)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        textField.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        
        self.textInputContentView.addSubview(textField)
        
        let views = ["textField" : textField]
        
        NSLayoutConstraint.constraints(withVisualFormat: "V:|[textField]|", options: [], metrics: nil, views: views).activate()
        NSLayoutConstraint.constraints(withVisualFormat: "H:|[textField]|", options: [], metrics: nil, views: views).activate()
        
        return textField
    }()
    
    @objc fileprivate func editingDidBegin() {
        if mfl_nilOrEmpty(textField.text) {
            setPlaceholder(toSmall: true, animated: true)
        }
        
        delegate?.textFieldViewEditingDidBegin(self)
    }
    
    @objc fileprivate func editingDidEnd() {
        
        delegate?.textFieldViewEditingDidEnd(self)
        
        if mfl_nilOrEmpty(textField.text) {
            setPlaceholder(toSmall: false, animated: true)
        }
        
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }
    
    @objc fileprivate func editingChanged() {
        delegate?.textFieldViewEditingChanged(self)
    }
    
    @objc fileprivate func editingDidEndOnExit() {
        delegate?.textFieldViewEditingDidEndOnExit(self)
    }
    
    override open func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        _ = textField
    }
}
