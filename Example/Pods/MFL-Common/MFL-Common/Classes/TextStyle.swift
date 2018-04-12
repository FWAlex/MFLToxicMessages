//
//  UIFont+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 25/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

public struct TextStyle {
    let font : UIFont
    let lineHeight : CGFloat
    
    public static let bigTitle     = TextStyle(font: UIFont.systemFont(ofSize: 36, weight: UIFontWeightMedium), lineHeight: CGFloat(36))
    public static let title        = TextStyle(font: UIFont.systemFont(ofSize: 24), lineHeight: CGFloat(29))
    public static let bigText      = TextStyle(font: UIFont.systemFont(ofSize: 21, weight: UIFontWeightMedium), lineHeight: CGFloat(26))
    public static let smallTitle   = TextStyle(font: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium), lineHeight: CGFloat(24))
    public static let text         = TextStyle(font: UIFont.systemFont(ofSize: 17), lineHeight: CGFloat(24))
    public static let smallText    = TextStyle(font: UIFont.systemFont(ofSize: 15), lineHeight: CGFloat(20))
    public static let tinyText     = TextStyle(font: UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold), lineHeight: CGFloat(20))
    
    public func attributedString(with string: String?, color: UIColor = .black, alignment: NSTextAlignment = .left, for range: NSRange? = nil) -> NSAttributedString? {
        
        guard let string = string else { return nil }
    
        return NSAttributedString.stringWith(string: string, style: self, color: color, alignment: alignment, for: range)
    }
    
    public init(font : UIFont, lineHeight : CGFloat) {
        self.font = font
        self.lineHeight = lineHeight
    }
}
