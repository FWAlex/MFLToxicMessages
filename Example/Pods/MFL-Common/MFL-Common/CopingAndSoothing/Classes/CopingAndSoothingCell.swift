//
//  CopingAndSoothingCell.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 23/10/2017.
//

import UIKit

class CopingAndSoothingCell: UITableViewCell, Reusable {

    fileprivate let textStyle = TextStyle(font: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium), lineHeight: 26)
    
    
    @IBOutlet fileprivate weak var label : UILabel!
    @IBOutlet fileprivate weak var bubble : CircleView!
    @IBOutlet fileprivate weak var bubbleContainerView : UIView!
    var style : Style? { didSet { update() } }
    var body : String? { didSet { update() } }
    var isBubbleHidden = true { didSet { bubbleContainerView.isHidden = isBubbleHidden } }
    
    func update() {
        bubble.backgroundColor = style?.textColor4
        label.attributedText = body?.attributedString(style: textStyle, color: style != nil ? style!.textColor4 : .white, alignment: .center)
    }
}
