//
//  MFLCustomChatHeaderView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

protocol MFLCustomChatHeaderViewDelegate : class {
    func mflCustomChatHeaderViewWantsToPresentTeam(_ sender: MFLCustomChatHeaderView)
}

class MFLCustomChatHeaderView: UICollectionReusableView, Identifiable {
    
    weak var delegate : MFLCustomChatHeaderViewDelegate?
    var style : Style? { didSet { updateStyle() } }
    
    static fileprivate let bodyText = "Start messaging our team of qualified counsellors."
    static fileprivate let bodyTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium),
                                                     lineHeight: 30)
    
    static fileprivate let horizPadding = CGFloat(24.0)
    static fileprivate let vertPadding = CGFloat(24.0)
    static fileprivate let buttonHeight = CGFloat(32.0)
    static fileprivate let interItemsPadding = CGFloat(24.0)

    @IBOutlet fileprivate weak var label: UILabel!
    @IBOutlet fileprivate weak var button: RoundedButton!
    
    @IBAction fileprivate func viewTeamTapped(_ sender: Any) {
        delegate?.mflCustomChatHeaderViewWantsToPresentTeam(self)
    }
    
    fileprivate func updateStyle() {
        if let style = style {
            button.setTitleColor(style.primary, for: .normal)
            button.backgroundColor = style.textColor4
            label.attributedText = MFLCustomChatHeaderView.bodyText.attributedString(style: MFLCustomChatHeaderView.bodyTextStyle,
                                                                                     color: style.textColor4,
                                                                                     alignment: .center)
        }
    }
    
    static func sizeThatFits(_ size: CGSize) -> CGSize {
        
        var height = 2 * vertPadding + interItemsPadding + buttonHeight
        let bodyAttrString = bodyText.attributedString(style: bodyTextStyle, alignment: .center)
        height += bodyAttrString.height(constraintTo: size.width - 2 * horizPadding)
        
        return CGSize(width: size.width, height: height)
    }
}
