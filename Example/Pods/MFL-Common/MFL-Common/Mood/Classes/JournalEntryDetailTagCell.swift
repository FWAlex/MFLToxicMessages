//
//  JournalEntryDetailTagCell.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

final class JournalEntryDetailTagCell : UITableViewCell, NibInstantiable, Reusable {
    
    @IBOutlet fileprivate var tagLabel : UILabel!
    @IBOutlet weak var tagImage: UIImageView!
    
    var style : Style? { didSet { updateStyle() } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tagImage.image = UIImage.template(named: "tag", in: .common)
        updateStyle()
    }
    
    fileprivate func updateStyle() {
        self.tagImage.tintColor = style != nil ? style!.primary : .mfl_green
        self.tagLabel.textColor = style != nil ? style!.textColor1 : .mfl_greyishBrown
    }
    
    var moodTag : String? {
        get { return tagLabel.text }
        set { tagLabel.text = newValue }
    }
    
}

