//
//  JournalEntryDetailNoteCell.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

final class JournalEntryDetailNoteCell: UITableViewCell, NibInstantiable, Reusable {
    
    fileprivate let noteTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightMedium),
                                              lineHeight: 24.0)

    @IBOutlet fileprivate weak var noteLabel: UILabel!
    
    var style : Style? { didSet { update() } }
    var noteText : String? { didSet { update() } }
    
    fileprivate func update() {
        let color = style != nil ? style!.textColor1 : .mfl_greyishBrown
        noteLabel.attributedText = noteTextStyle.attributedString(with: noteText,
                                                                  color: color)
    }
}
