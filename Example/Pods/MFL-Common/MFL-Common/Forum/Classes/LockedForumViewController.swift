//
//  LockedForumViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/10/2017.
//Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class LockedForumViewController: MFLViewController {
    
    var presenter : LockedForumPresenter!
    var style : Style!
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var viewPackagesButton : RoundedButton!
    
    private let labelTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 21, weight: UIFontWeightMedium), lineHeight: 26)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyStyle()
        shouldUseGradientBackground = true
        
        imageView.image = UIImage(named: "locked_forum", bundle: MFLCommon.shared.appBundle)
    }
    
    func applyStyle() {
        gradientLayerColors = style.gradient
        
        viewPackagesButton.backgroundColor = style.textColor4
        viewPackagesButton.setTitleColor(style.primary, for: .normal)
        
        label.attributedText = label.text?.attributedString(style: labelTextStyle,
                                                            color: style.textColor4,
                                                            alignment: .center)
    }
    
    @IBAction func didTapViewPackages(_ sender: Any) {
        presenter.userWantsToViewPackages()
    }
    
    
}

extension  LockedForumViewController : LockedForumPresenterDelegate {
    
}

