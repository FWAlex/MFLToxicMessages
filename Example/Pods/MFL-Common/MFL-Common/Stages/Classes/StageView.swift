//
//  StageView.swift
//  Pods
//
//  Created by Marc Blasi on 26/09/2017.
//
//

import UIKit

final class StageView: UIView, NibInstantiable {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightMedium)
        leftLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBold)
        
        self.leftView.backgroundColor = UIColor.black.withAlphaComponent(0.06)
    }
}
