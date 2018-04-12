//
//  CopingAndSoothingIntroViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 24/10/2017.
//
//

import UIKit

class CopingAndSoothingIntroViewController: MFLViewController {
    
    var presenter : CopingAndSoothingIntroPresenter!
    var style : Style!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tryNowButton: RoundedButton!
    
    fileprivate let infoTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium),
                                              lineHeight: 30)
    fileprivate let infoText = NSLocalizedString("This tool helps you remember what things you want to do more and what you want to do less.\n\nChoose them from our list or write your own.", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayerColors = style.gradient
        shouldUseGradientBackground = true
        
        infoLabel.attributedText = infoText.attributedString(style: infoTextStyle,
                                                             color: style.textColor4,
                                                             alignment: .center)
        tryNowButton.backgroundColor = style.textColor4
        tryNowButton.setTitleColor(style.primary, for: .normal)
    }
    
    @IBAction func didTapTryNow(_ sender: Any) {
        presenter.userWantsToTryNow()
    }
}

extension  CopingAndSoothingIntroViewController : CopingAndSoothingIntroPresenterDelegate {
    
}

