//
//  GoalsHeaderView.swift
//  MFLHalsa
//
//  Created by Jonathan Flintham on 16/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class GoalsHeaderView: UIView {
    var style : Style? {
        didSet {
            if let style = style {
                mainLabel.textColor = style.textColor4
                secondaryLabel.textColor = style.textColor4
            }
        }
    }
    
    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var secondaryLabel: UILabel!
    @IBOutlet private weak var secondaryLabelView: UIView!
    @IBOutlet private weak var stackView : UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainLabel.textColor = .mfl_greyishBrown
        secondaryLabel.textColor = .mfl_lifeSlate
    }
    
    var isSecondaryLabelHidden : Bool {
        get { return secondaryLabelView.isHidden }
        set { secondaryLabelView.isHidden = newValue }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainLabel.preferredMaxLayoutWidth = width * 0.8
    }
}

