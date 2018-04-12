//
//  ReflectionSpaceHeader.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 06/10/2017.
//

import UIKit

class ReflectionSpaceHeader: UICollectionReusableView {
    
    fileprivate static let verticalPadding = CGFloat(40)
    fileprivate static let horizontalPadding = CGFloat(24)

    fileprivate static let title = NSLocalizedString("Think of it as your own personal corner where you can add images and videos that make you feel safe.", comment: "")
    
    fileprivate static let titleStyle = TextStyle(font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium), lineHeight: 30)
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    var style : Style? {
        didSet { updateStyle() }
    }
    
    fileprivate func updateStyle() {
        titleLabel.attributedText = ReflectionSpaceHeader.title.attributedString(style: ReflectionSpaceHeader.titleStyle,
                                                                                 color: style?.textColor4 ?? .white,
                                                                                 alignment: .center)
    }
    
    static func size(for width: CGFloat) -> CGSize {
        var height = verticalPadding * 2
        
        let availableWidth = width - 2 * horizontalPadding
        
        let titleAttrString = title.attributedString(style: titleStyle, alignment: .center)
        height += titleAttrString.height(constraintTo: availableWidth)
        
        return CGSize(width: width, height: height)
    }
}
