//
//  TherapistChatViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 03/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

fileprivate let chatViewControllerSegueId = "ChatViewControllerSegueId"

class TherapistChatViewController: MFLViewController {
    
    var presenter : TherapistChatPresenter!
    var style : Style!
    
    private lazy var videoButton : UIBarButtonItem = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Video", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(didTapVideo(_:)), for: .touchUpInside)
        button.sizeToFit()
        
        return UIBarButtonItem(customView: button)
    }()
    fileprivate var chatViewController : MFLCustomChatViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInfoView(style)
        
        self.title = NSLocalizedString("Get More Help", comment: "")
        
        chatViewController.style = style
        
        gradientLayerColors = style.gradient
        shouldUseGradientBackground = true
        
        chatViewController.reload()
        
        navigationItem.rightBarButtonItem = videoButton
        
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    @IBAction func didTapTherapist(_ sender: Any) {
        presenter.userWantsToSeeTherapistDetails()
    }
    
    @IBAction func didTapMeetTheTeam(_ sender: Any) {
        presenter.userWantsToSeeTheTeam()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == chatViewControllerSegueId,
            let chatViewController = segue.destination as? MFLCustomChatViewController {

            self.chatViewController = chatViewController
            self.chatViewController.style = self.style
            self.chatViewController.delegate = self
            self.chatViewController.dataSource = self
        }
    }
    
    @objc private func didTapVideo(_ sender: Any) {
        presenter.userWantsToSeeVideoOptions()
    }
}

//MARK: - Helper
fileprivate extension TherapistChatViewController {
   
}

//MARK: - TherapistChatPresenterDelegate
extension TherapistChatViewController : TherapistChatPresenterDelegate {
    
    func therapistChatPresenterDidReceiveNewMessage(_ sender: TherapistChatPresenter, outgoing isOutgoing: Bool) {
        
        let shouldScroll = isOutgoing || (chatViewController.collectionView.contentOffset.y + chatViewController.collectionView.height >= chatViewController.collectionView.contentSize.height - 50)
        chatViewController.gotNewMessage(scrollsToBottom: shouldScroll)
    }
    
    func therapistChatPresenterDidReceiveNewMessage(_ sender: TherapistChatPresenter, count: Int, animated: Bool) {
        chatViewController.gotNewMessage(count: count, animated: animated)
    }
    
    func therapistChatPresenterDidRetrievePreviousMessages(_ sender: TherapistChatPresenter, count: Int) {
        chatViewController.loadPreviousMessages(count: count)
    }
    
    func therapistChatPresenter(_ sender: TherapistChatPresenter, didUpdateChatConnectedStatus connected: Bool) {
        chatViewController.isSendButtonEnabled = connected
    }
    
    func therapistChatPresenter(_ sender: TherapistChatPresenter, wantsToSetInputViewHidden isHidden: Bool) {
        chatViewController.setInputView(hidden: isHidden, animated: true)
    }
    
    func therapistPresenter(_ sender: TherapistChatPresenter,
                            wantsToShowInfo text: String?,
                            image: UIImage?,
                            isDismissable: Bool,
                            button: String?,
                            action: (() -> Void)?) {
        
        guard let text = text else {
            hideInfoView()
            return
        }
        
        setInfo(text: text, buttonTitle: button, action: action, image: image, isDismissable: isDismissable)
        showInfoView()
    }
}

//MARK: - MFLCustomChatViewControllerDelegate
extension TherapistChatViewController : MFLCustomChatViewControllerDelegate {
    
    func customChatViewController(_ sender: MFLCustomChatViewController, wantsToSend message: String) {
        presenter.userWantsToSend(message)
    }
    
    func customChatViewControllerWantsToShowPreviousMessages(_ sender: MFLCustomChatViewController) {
        presenter.retrievePreviousMessages()
    }
    
    func customChatViewControllerWantsToPresentTeam(_ sender: MFLCustomChatViewController) {
        presenter.userWantsToSeeTheTeam()
    }
}

//MARK: - MFLCustomChatViewControllerDataSource
extension TherapistChatViewController : MFLCustomChatViewControllerDataSource {
    
    func customChatViewControllerNumberOfMessages(_ sender: MFLCustomChatViewController) -> Int {
        return presenter.messageCount
    }
    
    func customChatViewController(_ sender: MFLCustomChatViewController, messageAt index: Int) -> MFLMessage {
        return presenter.message(at: index)
    }
}
