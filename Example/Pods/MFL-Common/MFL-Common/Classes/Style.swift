//
//  Style.swift
//  Pods
//
//  Created by Marc Blasi on 01/09/2017.
//
//

import Foundation

public protocol Style {
    var primary: UIColor { get }
    var secondary : UIColor { get }
    var gradient: [UIColor] { get }
    var textColor1: UIColor { get }
    var textColor2: UIColor { get }
    var textColor3: UIColor { get }
    var textColor4: UIColor { get }
}

extension MFLTextFieldView {
    
    func set(_ style: Style) {
        placeholderDefaultColor = style.primary
        separatorSuccessColor = style.primary
        textColor = style.textColor1
    }
    
}
