//
//  QuestionnaireBotViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD

fileprivate let messagesViewControllerSegueId = "MFLMessagesViewControllerSegue"

class QuestionnaireBotViewController: MFLViewController {
    
    var presenter : QuestionnaireBotPresenter!
    var style : Style!
    var allowUserToClose = false
    fileprivate var messagesViewController : MFLMessagesViewController!
    
    @IBOutlet weak var optionsInput: HorizontalButtonsView!
    
    fileprivate lazy var cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)
        button.addTarget(self, action: #selector(cancelTapped(sender:)), for: .touchUpInside)
        button.sizeToFit()
        
        return button
    }()
    
    fileprivate lazy var cancelBarBtn : UIBarButtonItem = {
        return UIBarButtonItem(customView: self.cancelButton)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesViewController.style = style
        
        optionsInput.delegate = self
        
        optionsInput.buttonsBackgroundColor = style.primary
        optionsInput.buttonsTitleColor = style.textColor4
        optionsInput.buttonsBorderColor = style.primary
        
        if allowUserToClose {
            navigationItem.leftBarButtonItem = cancelBarBtn
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewDidAppear()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == messagesViewControllerSegueId {
            messagesViewController = segue.destination as! MFLMessagesViewController
        }
    }
    
    func setOptionsInputHidden(_ hidden: Bool) {
        UIView.animate(withDuration: 0.1, animations: {
            self.optionsInput.alpha = hidden ? 0.0 : 1.0
        })
    }
    
    func cancelTapped(sender: Any) {
        presenter.userWantsToCancel()
    }
}

extension  QuestionnaireBotViewController : QuestionnaireBotPresenterDelegate {
    
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToSetInputType inputType: QuestionInputType) {
        
        switch inputType {
        case .text:
            optionsInput.isHidden = true
            messagesViewController.inputToolbar.isHidden = false
        case .options(let options):
            messagesViewController.inputToolbar.isHidden = true
            optionsInput.isHidden = false
            optionsInput.set(items: options)
            messagesViewController.view.endEditing(true)
        }
    }
    
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToAsk question: String, hasAnswers: Bool) {
        setOptionsInputHidden(!hasAnswers)
        messagesViewController.addIncomingMessage(text: question)
    }
    
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToRespond response: String) {
        messagesViewController.addIncomingMessage(text: response)
    }
    
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToSend answer: String) {
        messagesViewController.addOutgoingMessage(text: answer)
    }
    
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToCommitSend animated: Bool) {
        messagesViewController.finishSendingMessage(animated: animated)
    }
    
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToDisplay error: Error) {
        setOptionsInputHidden(false)
        showAlert(for: error)
    }
    
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToDisplayLoading isLoading: Bool) {
        if isLoading {
            HUD.show(.progress)
        } else {
            HUD.hide()
        }
    }
    
    func questionnaireBotPresenter(_ sender: QuestionnaireBotPresenter, wantsToAllowUserToClose shouldAllowClose: Bool) {
        if shouldAllowClose {
            cancelButton.setTitle(NSLocalizedString("Close", comment: ""), for: .normal)
            cancelButton.sizeToFit()
        }
        navigationItem.leftBarButtonItem = shouldAllowClose ? cancelBarBtn : nil
    }
}

extension  QuestionnaireBotViewController : HorizontalButtonsViewDelegate {
    
    func horizontalButtonsView(_ sender: HorizontalButtonsView, didSelect item: String, at index: Int) {
        setOptionsInputHidden(true)
        presenter.userSelectedAnwser(at: index)
    }
}
