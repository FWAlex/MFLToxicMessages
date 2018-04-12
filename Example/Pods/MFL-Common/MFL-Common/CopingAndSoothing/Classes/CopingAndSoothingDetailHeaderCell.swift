//
//  CopingAndSoothingDetailHeaderCell.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 27/10/2017.
//

import UIKit

class CopingAndSoothingDetailHeaderCell: UITableViewCell, Reusable {
    
    @IBOutlet private weak var label : UILabel!
    private let textStyle = TextStyle(font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightSemibold),
                                      lineHeight: 30)
    
    var style : Style? { didSet { update() } }
    var header : String? { didSet { update() } }
    
    private func update() {
        label.attributedText = header?.attributedString(style: textStyle,
                                                        color: style?.textColor1 ?? .mfl_purpleyGrey,
                                                        alignment: .center)
    }
}
