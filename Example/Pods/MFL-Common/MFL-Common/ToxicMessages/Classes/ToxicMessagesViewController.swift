//
//  ToxicMessagesViewController.swift
//  MFLSexualAbuse
//
//  Created by Alex Miculescu on 23/11/2017.
//Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

fileprivate let messagesSegueId = "ToxicMessagesMessagesSegueId"
fileprivate let beliefsSegueId = "ToxicMessagesBeliefsSegueId"

class ToxicMessagesViewController: MFLViewController {
    
    fileprivate var messagesViewController : ToxicMessagesContentViewController!
    fileprivate var beliefsViewController : ToxicMessagesContentViewController!
    
    @IBOutlet weak var messagesView: UIView!
    @IBOutlet weak var beliefsView: UIView!
    
    private lazy var segmentedControl : UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
            NSLocalizedString("Messages", comment: ""),
            NSLocalizedString("Belifs", comment: "")
            ])
        
        segmentedControl.addTarget(self,
                                   action: #selector(ToxicMessagesViewController.didChageType(_:)),
                                   for: .valueChanged)
        return segmentedControl
    }()
    
    var presenter : ToxicMessagesPresenter!
    var style : Style!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesViewController.type = .messages
        beliefsViewController.type = .beliefs

        beliefsView.isHidden = true
        
        navigationItem.titleView = segmentedControl
        segmentedControl.selectedSegmentIndex = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let identifier = segue.identifier, let viewController = segue.destination as? ToxicMessagesContentViewController {
            if identifier == messagesSegueId {
                messagesViewController = viewController
            }
            else if identifier == beliefsSegueId {
                beliefsViewController = viewController
            }
        }
    }
    
    @objc private func didChageType(_ sender: Any) {
        guard let segmentedControl = sender as? UISegmentedControl else { return }

        messagesView.isHidden = segmentedControl.selectedSegmentIndex == 1
        beliefsView.isHidden = segmentedControl.selectedSegmentIndex == 0
    }
}

extension  ToxicMessagesViewController : ToxicMessagesPresenterDelegate {
    
}

