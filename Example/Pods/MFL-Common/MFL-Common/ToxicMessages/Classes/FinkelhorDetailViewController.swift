//
//  FinkelhorDetailViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 28/11/2017.
//
//

import UIKit
import TSMarkdownParser

class FinkelhorDetailViewController: MFLViewController {
    
    var presenter : FinkelhorDetailPresenter!
    var style : Style!
    
    @IBOutlet weak var behavioursButton: RoundedButton!
    @IBOutlet weak var markDownLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyStyle()
     
        let markDown = TSMarkdownParser.standard().attributedString(fromMarkdown: presenter.markdownString)
        let mutableAttributedText = markDown.mutableCopy() as! NSMutableAttributedString
        mutableAttributedText.addAttribute(NSForegroundColorAttributeName, value: style.textColor1, range: NSRange(location: 0, length: mutableAttributedText.length))
        mutableAttributedText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium), range: NSRange(location: 0, length: mutableAttributedText.length))

        
        let mutableAttrString = markDown.mutableCopy() as! NSMutableAttributedString
        mutableAttrString.setlineHeight(26)

        
        markDownLabel.attributedText = mutableAttrString
    }
    
    func applyStyle() {
        behavioursButton.backgroundColor = style.primary
        behavioursButton.setTitleColor(style.textColor4, for: .normal)
    }
    
    @IBAction func didTapBehaviours(_ sender: Any) {
        presenter.userWantsToViewBehaviour()
    }
}

extension  FinkelhorDetailViewController : FinkelhorDetailPresenterDelegate {
    
}

