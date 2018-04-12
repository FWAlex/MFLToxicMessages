//
//  CopingAndSoothingDetailCell.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 26/10/2017.
//

import UIKit

struct CopingAndSoothingDetailData {
    let text : String
    let isSelected : Bool
}

class CopingAndSoothingDetailCell : UITableViewCell, Reusable {
    
    @IBOutlet fileprivate weak var label : UILabel!
    @IBOutlet fileprivate weak var separator : UIView!
    @IBOutlet fileprivate weak var checkMarkImageView : UIImageView!

    fileprivate let checkImage = UIImage.template(named: "success_mark_green", in: .common)
    fileprivate let textStyle = TextStyle(font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium), lineHeight: 21)
    
    var style : Style? { didSet { updateStyle() } }
    var item : CopingAndSoothingDetailData? { didSet { updateItem() } }
    
    
    private func updateItem() {
        checkMarkImageView.image = item?.isSelected ?? false ? checkImage : nil
        label.attributedText = item?.text.attributedString(style: textStyle, color: style?.textColor1 ?? .mfl_greyishBrown)
    }
    
    private func updateStyle() {
        checkMarkImageView.tintColor = style?.primary
        separator.backgroundColor = style?.textColor3
        label.attributedText = item?.text.attributedString(style: textStyle, color: style?.textColor1 ?? .mfl_greyishBrown)
    }
}
