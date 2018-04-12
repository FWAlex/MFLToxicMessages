//
//  UITextField+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 16/05/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

extension UITextField {
    
    typealias Action = (() -> Void)
    
    private class InputAccessoryButton : UIButton {
        var buttonAction: Action?
    }
    
    func addToolBar(backAction: Action? = nil, nextAction: Action? = nil, style: Style? = nil) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor =  style != nil ? style!.primary : .mfl_green
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        
        let backBarButtonItem = UIBarButtonItem(customView: inputButton(with: backAction, isNext: false, style: style))
        let nextBarButtonItem = UIBarButtonItem(customView: inputButton(with: nextAction, isNext: true, style: style))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([backBarButtonItem, nextBarButtonItem, spaceButton, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        inputAccessoryView = toolBar
    }
    
    private func inputButton(with action: Action?, isNext: Bool, style: Style? = nil) -> InputAccessoryButton {
        let button = InputAccessoryButton()
        
        let nextImage = UIImage.template(named: "arrowDown", in: .common)
        let prevImage = UIImage.template(named: "arrowUp", in: .common)
        
        button.setBackgroundImage( isNext ? nextImage : prevImage, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        let tintColor = style != nil ? style!.primary : .mfl_green
        button.tintColor = action != nil ? tintColor : tintColor.withAlphaComponent(0.4)

        button.isUserInteractionEnabled = action != nil
        button.buttonAction = action
        
        return button
    }
    
    @objc private func donePressed() {
        resignFirstResponder()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if let inputButton = sender as? InputAccessoryButton {
            inputButton.buttonAction?()
        }
    }
}
