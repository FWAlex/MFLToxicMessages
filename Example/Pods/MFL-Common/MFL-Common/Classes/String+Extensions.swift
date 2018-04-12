//
//  String+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 20/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
        
//        subscript (i: Int) -> String {
//            return String(self[i] as Character)
//        }
        
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[Range(start ..< end)]
    }
    
    public var removeMultileNewLines : String {
        return replacingOccurrences(of: "\\n+", with: "\n", options: .regularExpression, range: nil)
    }
    
    public var length : Int {
        return characters.count
    }
    
    func height(constraintTo width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let height = self.boundingRect(with: constraintRect,
                                       options: .usesLineFragmentOrigin,
                                       attributes: [NSFontAttributeName: font], context: nil).height
        return height
    }
    
    func text(with style: TextStyle) -> NSAttributedString? {
        return NSAttributedString.stringWith(string: self, style: style)
    }
    
    public func attributedString(style: TextStyle = TextStyle.text, color: UIColor = UIColor.black, alignment: NSTextAlignment = .left, for range: NSRange? = nil) -> NSAttributedString {
        return NSAttributedString.stringWith(string: self, style: style, color: color, alignment: alignment, for: range)
    }
}

extension NSString {
    
    var fullRange : NSRange {
        return NSMakeRange(0, length)
    }
}

extension NSAttributedString {
    
    func height(constraintTo width: CGFloat) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let height = self.boundingRect(with: constraintRect,
                                       options: [.usesLineFragmentOrigin, .usesFontLeading],
                                       context: nil).height
        return height
    }
    
}

extension NSAttributedString {
    
    public static func stringWith(string: String, style: TextStyle = TextStyle.text, color: UIColor = UIColor.black, alignment: NSTextAlignment = .left, for range: NSRange? = nil) -> NSAttributedString {
        
        let attrStr = NSMutableAttributedString(string: string)
        attrStr.set(style: style, color: color, alignment: alignment, for: range)
        return attrStr
    }
    
    public func attributedString(style: TextStyle = TextStyle.text, color: UIColor = UIColor.black, alignment: NSTextAlignment = .left, for range: NSRange? = nil) -> NSAttributedString {
        return string.attributedString(style: style, color: color, alignment: alignment, for: range)
    }
}

public extension NSMutableAttributedString {
    
    func setlineHeight(_ lineHeight: CGFloat, alignment: NSTextAlignment = .left, for range: NSRange? = nil) {
        
        let actualRange = range != nil ? range! : string.fullRange
        
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        
        paragraphStyle.alignment = alignment
        
        addAttributes([NSParagraphStyleAttributeName : paragraphStyle], range: actualRange)
    }
    
    func setFont(_ font: UIFont, for range: NSRange? = nil) {
        
        let actualRange = range != nil ? range! : string.fullRange
        addAttributes([NSFontAttributeName : font], range: actualRange)
    }
    
    func setColor(_ color: UIColor, for range: NSRange? = nil) {
        
        let actualRange = range != nil ? range! : string.fullRange
        addAttributes([NSForegroundColorAttributeName : color], range: actualRange)
    }
    
    func set(style: TextStyle = TextStyle.text, color: UIColor = UIColor.black, alignment: NSTextAlignment = .left, for range: NSRange? = nil) {
        setlineHeight(style.lineHeight, alignment: alignment, for: range)
        setFont(style.font, for: range)
        setColor(color, for: range)
    }
}
