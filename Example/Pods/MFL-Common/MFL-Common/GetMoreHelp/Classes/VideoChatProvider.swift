//
//  VideoChatProvider.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 12/03/2018.
//

import UIKit

public protocol VideoChatProvider {
    static func sessionWith(apiKey: String, sessionId: String, delegate: VideoChatProviderSessionDelegate?) -> VideoChatProviderSession?
    static func publisher(delegate: VideoChatProviderPublisherDelegate?) -> VideoChatProviderPublisher?
    static func subscriber(stream: VideoChatProviderStream, delegate: VideoChatProviderSubscriberDelegate?) -> VideoChatProviderSubscriber?
}

//MARK: - Session
public protocol VideoChatProviderSessionDelegate : class {
    func VideoChatProviderSessionDidConnect(_ sender: VideoChatProviderSession)
    func videoChatProviderSessionDidDisconnect(_ sender: VideoChatProviderSession)
    func videoChatProviderSession(_ sender: VideoChatProviderSession, didFailWithError error: Error)
    func videoChatProviderSession(_ sender: VideoChatProviderSession, streamCreated stream: VideoChatProviderStream)
    func videoChatProviderSession(_ sender: VideoChatProviderSession, streamDestroyed stream: VideoChatProviderStream)
}

public protocol VideoChatProviderSession {
    weak var delegate : VideoChatProviderSessionDelegate? { get set }
    
    func connect(with token: String, error: inout Error?)
    func publish(_ publisher: VideoChatProviderPublisher, error: inout Error?)
    func subscribe(_ subscriber: VideoChatProviderSubscriber, error: inout Error?)
}

//MARK: - Publisher
public protocol VideoChatProviderPublisherDelegate : class {
    func videoChatProviderPublisher(_ sender: VideoChatProviderPublisher, streamDestroyed stream: VideoChatProviderStream)
    func videoChatProviderPublisher(_ sender: VideoChatProviderPublisher, didFailWithError error: Error)
}

public protocol VideoChatProviderPublisher : class {
    weak var delegate : VideoChatProviderPublisherDelegate? { get set }
    var view : UIView? { get }
    var publishVideo : Bool { get set }
    var publishAudio : Bool { get set }
}

//MARK - Subscriber
public protocol VideoChatProviderSubscriberDelegate : class {
    func videoChatProviderSubscriberDidConnect(_ sender: VideoChatProviderSubscriber)
    func videoChatProviderSubscriberDidDisconnect(_ sender: VideoChatProviderSubscriber)
    func videoChatProviderSubscriber(_ sender: VideoChatProviderSubscriber, didSetVideo isVideoEnabled: Bool)
    func videoChatProviderSubscriber(_ sender: VideoChatProviderSubscriber, didFailWithError error: Error)
}

public protocol VideoChatProviderSubscriber : class {
    weak var delegate : VideoChatProviderSubscriberDelegate? { get set }
    var view : UIView? { get }
    var streamId : String? { get }
}

//MARK: - Stream
public protocol VideoChatProviderStream {
    var streamId : String { get }
}

