//
//  VideoChatPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 14/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class VideoChatPresenterImplementation: VideoChatPresenter {
    
    weak var delegate : VideoChatPresenterDelegate?
    
    fileprivate let interactor : VideoChatInteractor
    fileprivate let wireframe : VideoChatWireframe
    fileprivate let videoSessionManager : VideoSessionManager
    fileprivate let session : Session
    
    typealias Dependencies = HasVideoChatInteractor & HasVideoChatWireframe & HasVideoSessionManager & HasSession
    init(_ dependencies: Dependencies) {
        interactor = dependencies.videoChatInteractor
        wireframe = dependencies.videoChatWireframe
        session = dependencies.session
        videoSessionManager = dependencies.videoSessionManager
        videoSessionManager.delegate = self
    }
    
    func viewDidLoad() {
        videoSessionManager.start()
    }
    
    func userWantsToClose() {
        wireframe.close()
    }
    
    var title : String {
        return NSLocalizedString("On call with", comment: "") + " \(session.teamMemberFirstName)"
    }
    
    var waitingText : String {
        return NSLocalizedString("Waiting for", comment: "") + " \(session.teamMemberFirstName)"
    }
    
    var teamMemberImageUrlString : String {
        return session.teamMemberImageUrlString
    }
    
    var isCameraActive : Bool {
        get { return videoSessionManager.isPublishingVideo }
        set { videoSessionManager.isPublishingVideo = newValue }
    }
    
    var isMicActive : Bool {
        get { return videoSessionManager.isPublishingAudio }
        set { videoSessionManager.isPublishingAudio = newValue }
    }
}

//MARK: VideoSessionManagerDelegate
extension VideoChatPresenterImplementation: VideoSessionManagerDelegate {
    
    func videoSessionManagerRequiresPublisherView(_ sender: VideoSessionManager) -> UIView? {
        return delegate?.presenterRequiresPublisherView(self)
    }
    
    func videoSessionManagerRequiresSubscriberView(_ sender: VideoSessionManager) -> UIView? {
        return delegate?.presenterRequiresSubscriberView(self)
    }
    
    func videoSessionManager(_ sender: VideoSessionManager, wantsToShowActivity inProgress: Bool) {
        delegate?.videoChatPresenter(self, wantsToShowActivity: inProgress)
    }
    
    func videoSessionManagerVideoSessionDidDisconnect(_ sender: VideoSessionManager) {
        
        showAlert(title: NSLocalizedString("Session disconnected", comment: ""),
                  message: NSLocalizedString("The video session has disconnected", comment: "")) { [weak self] in
            self?.wireframe.close()
        }
    }
    
    func videoSessionManagerDidChangeSubscriberVideoState(_ sender: VideoSessionManager) {
        if sender.subscriberConnected {
            delegate?.videoChatPresenter(self, whatsToSetTeamMemberImageVisible: !sender.subscriberVideoEnabled)
        } else {
            delegate?.videoChatPresenter(self, whatsToSetTeamMemberImageVisible: true)
        }
    }
    
    func videoSessionManagerDidChangeSubscriberConnectionState(_ sender: VideoSessionManager) {
        delegate?.videoChatPresenter(self, whatsToSetTeamMemberImageVisible: !sender.subscriberVideoEnabled)
        delegate?.videoChatPresenter(self, whatsToSetWaitingMessageVisible: !sender.subscriberConnected)
    }
    
    // --- Error ---
    func videoSessionManager(_ sender: VideoSessionManager, errorOccurred error: Error) {
        
        if let error = error as? MFLError, error.displayMessage == "No video session" {
            showAlert(title: NSLocalizedString("Counsellor offline", comment: ""),
                      message: NSLocalizedString("Your counsellor is not online right now. Use chat if you have questions.", comment: "")) { [weak self] in
                        self?.wireframe.close()
            }
        
        } else {
            delegate?.presenter(self, errorOccurred: error)
        }
    }
}

//MARK: - Helper
fileprivate extension VideoChatPresenterImplementation {
    
    func showAlert(title: String, message: String, action: (() -> Void)?) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel) { _ in
            action?()
        }
        
        alert.addAction(okAction)
        
        delegate?.videoChatPresenter(self, wantsToShow: alert)
    }
}


