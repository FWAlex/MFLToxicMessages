//
//  BlockingQuestionViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

public enum BlockingQuestionOption {
    case yes
    case no
}

public class BlockingQuestionViewController: UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public typealias Action = (BlockingQuestionOption) -> Void
    public var action : Action?
    
    @IBOutlet public weak var yesButton: RoundedButton!
    @IBOutlet public weak var noButton: RoundedButton!
    
    
    @IBOutlet fileprivate weak var smallTitleLabel: UILabel!
    @IBOutlet fileprivate weak var bigTitleLabel: UILabel!
    @IBOutlet fileprivate weak var infoTitleLabel: UILabel!
    @IBOutlet fileprivate weak var infoBodyLabel: UILabel!
    
    open var smallTitle : NSAttributedString? {
        get { return smallTitleLabel.attributedText }
        set { smallTitleLabel.attributedText = newValue }
    }
    
    open var bigTitle : NSAttributedString? {
        get { return bigTitleLabel.attributedText }
        set { bigTitleLabel.attributedText = newValue }
    }
    
    open var infoTitle : NSAttributedString? {
        get { return infoTitleLabel.attributedText }
        set {
            infoTitleLabel.isHidden = mfl_nilOrEmpty(attrStr: newValue)
            infoTitleLabel.attributedText = newValue
        }
    }
    
    open var infoBody : NSAttributedString? {
        get { return infoBodyLabel.attributedText }
        set {
            infoBodyLabel.isHidden = mfl_nilOrEmpty(attrStr: newValue)
            infoBodyLabel.attributedText = newValue
        }
    }
    
    @IBAction fileprivate func yesTapped(_ sender: Any) {
        action?(.yes)
    }
    
    @IBAction fileprivate func noTapped(_ sender: Any) {
        action?(.no)
    }
    
}



