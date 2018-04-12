//
//  MoodTagCell.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 04/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

final class MoodTagCell: UITableViewCell, Reusable, NibInstantiable {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        self.selectedImageView.tintColor = .white
    }
    
    @IBOutlet fileprivate weak var selectedImageView: UIImageView!
    @IBOutlet fileprivate weak var tagNameLabel: UILabel!
    
    var name : String? {
        get { return tagNameLabel.text }
        set { tagNameLabel.text = newValue }
    }
    
    override var isSelected: Bool {
        didSet {
            selectedImageView.image = isSelected ? UIImage.template(named: "success_mark_green", in: Bundle.subspecBundle(named: "Common")) : nil
        }
    }
}
