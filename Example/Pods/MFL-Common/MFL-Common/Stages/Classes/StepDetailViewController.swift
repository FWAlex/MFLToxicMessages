//
//  FileViewController.swift
//  Pods
//
//  Created by Marc Blasi on 04/10/2017.
//
//

import UIKit
import TSMarkdownParser
import AVKit
import AVFoundation

class StepDetailViewController: MFLViewController {
    
    var presenter : StepDetailPresenter!
    var style: Style!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.update(with: presenter.step)
    }
    
    fileprivate func update(with step: StepPage) {
        let markDown = TSMarkdownParser.standard().attributedString(fromMarkdown: step.content)
        let mutableAttributedText = markDown.mutableCopy() as! NSMutableAttributedString
        
        mutableAttributedText.addAttribute(NSForegroundColorAttributeName, value: style.textColor1, range: NSRange(location: 0, length: mutableAttributedText.length))
        
        textView.attributedText = mutableAttributedText
        
        
        if let urlString = presenter.step.media, let url = URL(string: urlString) {
            let playerController = AVPlayerViewController()
            playerController.view.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin]
            self.addChildViewController(playerController)
            textView.addSubview(playerController.view)
            let width = view.frame.width
            let height = view.frame.width / 375.0 * 210.0
            playerController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            textView.textContainerInset = UIEdgeInsets(top: height+32, left: 10, bottom: 15, right: 10)
            playerController.player = AVPlayer(url: url)
        }
        else {
            textView.textContainerInset = UIEdgeInsets(top: 32, left: 10, bottom: 15, right: 10)
        }
    }
    
}
