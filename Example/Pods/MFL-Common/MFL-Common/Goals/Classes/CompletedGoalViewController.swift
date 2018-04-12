//
//  CompletedGoalViewController.swift
//  MFLHalsa
//
//  Created by Jonathan Flintham on 17/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class CompletedGoalViewController: MFLViewController {

    var dismiss: (() -> Void)?
    var style : Style!
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var mountainsImageView: UIImageView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var completedButton: RoundedButton!
    
    
    @IBOutlet weak var dismissButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.tintColor = .mfl_greyishBrown
        
        gradientLayerColors = style.gradient
        shouldUseGradientBackground = true
        
        primaryLabel.textColor = style.textColor4
        secondaryLabel.textColor = style.textColor4
        flagImageView.image = UIImage(named: "flag", bundle: MFLCommon.shared.appBundle)
        mountainsImageView.image = UIImage(named: "mountains_completed", bundle: .goals)
        completedButton.setTitleColor(style.primary, for: .normal)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss?()
    }
}
