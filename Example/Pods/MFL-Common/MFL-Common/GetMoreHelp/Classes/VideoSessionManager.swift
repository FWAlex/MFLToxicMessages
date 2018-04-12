//
//  sessionManager.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 15/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import UIKit

protocol HasVideoSessionManager {
    var videoSessionManager : VideoSessionManager! { get }
}

protocol VideoSessionManagerDelegate : class {
    
    func videoSessionManagerRequiresPublisherView(_ sender: VideoSessionManager) -> UIView?
    func videoSessionManagerRequiresSubscriberView(_ sender: VideoSessionManager) -> UIView?
    func videoSessionManager(_ sender: VideoSessionManager, wantsToShowActivity inProgress: Bool)
    func videoSessionManagerVideoSessionDidDisconnect(_ sender: VideoSessionManager)
    func videoSessionManagerDidChangeSubscriberConnectionState(_ sender: VideoSessionManager)
    func videoSessionManagerDidChangeSubscriberVideoState(_ sender: VideoSessionManager)
    
    // --- Error
    func videoSessionManager(_ sender: VideoSessionManager, errorOccurred error: Error)
}

class VideoSessionManager {
    
    weak var delegate: VideoSessionManagerDelegate?
    fileprivate let videoChatProvider : VideoChatProvider.Type
    
    fileprivate let session : Session
    fileprivate let networkManager : NetworkManager
    
    fileprivate var videoChatProviderSession : VideoChatProviderSession!
    
    fileprivate var publisher : VideoChatProviderPublisher?
    fileprivate var publisherView : UIView?
    
    fileprivate var subscriber : VideoChatProviderSubscriber?
    fileprivate var subscriberView : UIView?
    
    fileprivate(set) var subscriberVideoEnabled = false
    fileprivate(set) var subscriberConnected = false
    
    init(_ dependencies: HasNetworkManager & HasSession & HasVideoChatProvider) {
        session = dependencies.session
        networkManager = dependencies.networkManager
        videoChatProvider = dependencies.videoChatProvider
    }
    
    deinit {
        subscriber?.delegate = nil
        publisher?.delegate = nil
    }
    
    func start() {
        
        delegate?.videoSessionManager(self, wantsToShowActivity: true)
        
        networkManager.getVideoSessionTokens(for: session) { [weak self] result in
            
            guard let sself = self else { return }
            
            sself.delegate?.videoSessionManager(sself, wantsToShowActivity: false)
            
            switch result {
            case .success(let json):
                if let videoSessionData = VideoSessionData(json: json["content"]) {
                    sself.start(with: videoSessionData)
                } else {
                    sself.delegate?.videoSessionManager(sself, errorOccurred: MFLError(title: NSLocalizedString("An Error Occured", comment: "") ,
                                                                                       message: NSLocalizedString("Could not retrieve video session.", comment: "")))
                }
            case .failure(let error): sself.delegate?.videoSessionManager(sself, errorOccurred: error)
            }
            
        }
    }
    
    var isPublishingVideo : Bool {
        get {
            guard let publisher = publisher else { return false }
            return publisher.publishVideo
        }
        set {
            if let publisher = publisher {
                publisher.publishVideo = newValue
            }
        }
    }
    
    var isPublishingAudio : Bool {
        get {
            guard let publisher = publisher else { return false }
            return publisher.publishAudio
        }
        set {
            if let publisher = publisher {
                publisher.publishAudio = newValue
            }
        }
    }
    
    func toggleVideo() {
        guard let publisher = publisher else { return }
        publisher.publishVideo = !publisher.publishVideo
    }
    
    func toggleAudio() {
        guard let publisher = publisher else { return }
        publisher.publishAudio = !publisher.publishAudio
    }
    
    fileprivate func start(with videoSessionData: VideoSessionData) {
        videoChatProviderSession = videoChatProvider.session(with: videoSessionData, delegate: self)
        perform() { (error: inout Error?) in self.videoChatProviderSession.connect(with: videoSessionData.token, error: &error) }
    }
    
    // MARK: Publish
    fileprivate func publish() {
        
        publisher = videoChatProvider.publisher(delegate: self)
        
        perform() { [weak self] (error: inout Error?) in
            guard let publisher = self?.publisher else { return }
            self?.videoChatProviderSession.publish(publisher, error: &error)
        }
        
        publisherView = delegate?.videoSessionManagerRequiresPublisherView(self)
        
        if let publisherView = publisherView,
            let view = publisher?.view {
            
            add(subview: view, toView: publisherView)
        }
    }
    
    fileprivate func cleanupPublisher() {
        publisher?.view?.removeFromSuperview()
        publisher = nil
    }
    
    //MARK: Subscribe
    fileprivate func subscribe(stream: VideoChatProviderStream) {
        
        subscriber = videoChatProvider.subscriber(stream: stream, delegate: self)
        
        perform() { [weak self] (error: inout Error?) in
            guard let subscriber = self?.subscriber else { return }
            self?.videoChatProviderSession.subscribe(subscriber, error: &error)
        }
    }

    func cleanupSubscriber() {
        subscriber?.view?.removeFromSuperview()
        subscriber = nil
    }
}

//MARK: - VideoChatProviderSessionDelegate
extension VideoSessionManager : VideoChatProviderSessionDelegate {
    
    func VideoChatProviderSessionDidConnect(_ sender: VideoChatProviderSession) {
        publish()
    }
    
    func videoChatProviderSessionDidDisconnect(_ sender: VideoChatProviderSession) {
        delegate?.videoSessionManagerVideoSessionDidDisconnect(self)
    }
    
    func videoChatProviderSession(_ sender: VideoChatProviderSession, didFailWithError error: Error) {
        delegate?.videoSessionManager(self, errorOccurred: error)
    }
    
    func videoChatProviderSession(_ sender: VideoChatProviderSession, streamCreated stream: VideoChatProviderStream) {
        subscribe(stream: stream)
    }
    
    func videoChatProviderSession(_ sender: VideoChatProviderSession, streamDestroyed stream: VideoChatProviderStream) {
        if self.subscriber?.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
}

//MARK: - VideoChatProviderPublisherDelegate
extension VideoSessionManager : VideoChatProviderPublisherDelegate {
   
    func videoChatProviderPublisher(_ sender: VideoChatProviderPublisher, streamDestroyed stream: VideoChatProviderStream) {
        cleanupPublisher()
    }
    
    func videoChatProviderPublisher(_ sender: VideoChatProviderPublisher, didFailWithError error: Error) {
        cleanupPublisher()
    }
}

//MARK: - VideoChatProviderSubscriberDelegate
extension VideoSessionManager : VideoChatProviderSubscriberDelegate {
   
    func videoChatProviderSubscriberDidConnect(_ sender: VideoChatProviderSubscriber) {
        subscriberConnected = true
        subscriberVideoEnabled = true
        
        delegate?.videoSessionManagerDidChangeSubscriberConnectionState(self)
        
        subscriberView = delegate?.videoSessionManagerRequiresSubscriberView(self)
        
        if let subscriberView = subscriberView,
            let view = self.subscriber? .view {
            
            add(subview: view, toView: subscriberView)
        }
    }
    
    func videoChatProviderSubscriberDidDisconnect(_ sender: VideoChatProviderSubscriber) {
        subscriberConnected = false
        delegate?.videoSessionManagerDidChangeSubscriberConnectionState(self)
    }
    
    func videoChatProviderSubscriber(_ sender: VideoChatProviderSubscriber, didSetVideo isVideoEnabled: Bool) {
        subscriberVideoEnabled = isVideoEnabled
        delegate?.videoSessionManagerDidChangeSubscriberVideoState(self)
    }
    
    func videoChatProviderSubscriber(_ sender: VideoChatProviderSubscriber, didFailWithError error: Error) {
        //TODO: Call delegate specific method
    }
}




//MARK: - Helper
extension VideoSessionManager {

    fileprivate func perform(_ action: (inout Error?)->()) {
        
        var error: Error? = nil
        action(&error)
        
        if let error = error {
            delegate?.videoSessionManager(self, errorOccurred: error)
        }
    }
    
    fileprivate func add(subview: UIView, toView view: UIView) {
        
        view.addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints =
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|", options: [], metrics: nil, views: ["subview" : subview]) +
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[subview]|", options: [], metrics: nil, views: ["subview" : subview])
        
        view.addConstraints(constraints)
    }
}

fileprivate extension VideoChatProvider {
    
    static func session(with data: VideoSessionData, delegate: VideoChatProviderSessionDelegate?) -> VideoChatProviderSession? {
        return sessionWith(apiKey: data.apiKey, sessionId: data.sessionId, delegate: delegate)
    }
}
