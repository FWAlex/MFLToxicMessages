//
//  RTCManager.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/05/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

fileprivate let event_sendMessage = "messages::send"
fileprivate let event_messagesThread = "messages::thread"
fileprivate let event_groupsList = "groups::list"
fileprivate let event_messageReceived = "messages::new"
fileprivate let event_questionnairesNew = "questionnaires::new"
fileprivate let event_questionnairesDeclined = "questionnaires::declined"
fileprivate let event_newSession = "sessions::new"

fileprivate let messageLimit = 10

enum RTCConnectionStatus {
    case connected
    case disconnected
}

protocol RTCManagerObserver : class {
    func rtcManager(_ sender: RTCManager, didReceive message: Message)
    func rtcManager(_ sender: RTCManager, didReceive messages: [Message])
    func rtcManager(_ sender: RTCManager, didReceivePrevious messages: [Message])
    func rtcManager(_ sender: RTCManager, didChangeStatus status: RTCConnectionStatus)
    func rtcManager(_ sender: RTCManager, didReceive questionnaire: Questionnaire)
    func rtcManager(_ sender: RTCManager, didDeclineQuestionnaireWith id: String)
}

public struct RTCManagerDependecies : HasSocketManager, HasNetworkManager, HasUserDataStore, HasMessageDataStore, HasQuestionnaireDataStore {
    public var socketManager: SocketManager!
    public var networkManager: NetworkManager!
    public var userDataStore: UserDataStore!
    public var questionnaireDataStore: QuestionnaireDataStore!
    public var messageDataStore: MessageDataStore!
    
    public init(socketManager: SocketManager,
                networkManager: NetworkManager,
                userDataStore: UserDataStore,
                questionnaireDataStore: QuestionnaireDataStore,
                messageDataStore: MessageDataStore) {
    
        self.socketManager = socketManager
        self.networkManager = networkManager
        self.userDataStore = userDataStore
        self.questionnaireDataStore = questionnaireDataStore
        self.messageDataStore = messageDataStore
    
    }
    
}

public final class RTCManager {
 
    fileprivate(set) var status = RTCConnectionStatus.disconnected
    
    fileprivate let _socketManager : SocketManager
    fileprivate let _messageDataStore : MessageDataStore
    fileprivate let _user : User!
    fileprivate let _questionnaireStore : QuestionnaireDataStore
    fileprivate var _observers = NSHashTable<AnyObject>.weakObjects()
    fileprivate var _messages = [Message]()
    
    public typealias RTCManagerDependencies = HasSocketManager & HasUserDataStore & HasMessageDataStore & HasQuestionnaireDataStore
    
    public init(_ dependencies: RTCManagerDependencies) {
        _socketManager = dependencies.socketManager
        _user = dependencies.userDataStore.currentUser()
        _questionnaireStore = dependencies.questionnaireDataStore
        _messageDataStore = dependencies.messageDataStore
        
        _socketManager.add(observer: self)
        _socketManager.connect()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self._socketManager.emit(event_groupsList)
        }
    }
    
    deinit {
        _socketManager.remove(observer: self)
    }
    
    func send(message: String) {
        _messageDataStore.send(message: message) { _ in }
    }
    
    func message(at index: Int) -> Message {
        return _messages[index]
    }
    
    func messagesCount() -> Int {
        return _messages.count
    }
    
    func add(observer: RTCManagerObserver) {
        _observers.add(observer)
        observer.rtcManager(self, didChangeStatus: self.status)
    }
    
    func remove(observer: RTCManagerObserver) {
        _observers.remove(observer)
    }
    
    func retrievePreviousMessages() {
        _messageDataStore.getMessages(offset: _messages.count) { [unowned self] messages in
            self._messages.insert(contentsOf: messages, at: 0)
            self._notifyReceivedPrevious(messages)
        }
    }
    
    func retrieveInitialMessages() {
        _messageDataStore.getMessages(offset: 0) { [unowned self] messages in
            self._messages.append(contentsOf: messages)
            self._notifyReceived(messages)
        }
    }
}

//MARK: - SocketManagerObserver
extension RTCManager : SocketManagerObserver {
    
    func socketManagerDidConnect(_ sender: SocketManager) {
        status = .connected
        _notifyStatusChange()
    
        _retrieveMessages(after: _messages.last)
    }
    
    func socketManager(_ sender: SocketManager, didDisconnectWith error: NSError?) {
        status = .disconnected
        _notifyStatusChange()
    }
    
    func socketManager(_ sender: SocketManager, didReceive event: String, with data: MFLJson?) {
        _handle(event, data: data)
    }
}

//MARK: - Helper
fileprivate extension RTCManager {
    
    func _retrieveMessages(after message: Message?) {
        if status == .connected {
            
            let handler = { [unowned self] (messages: [Message]) in
                self._messages.append(contentsOf: messages)
                self._notifyReceived(messages)
            }
            
            if let message = message {
                _messageDataStore.getMessages(after: message, handler: handler)
            } else {
                _messageDataStore.getMessages(offset: 0, handler: handler)
            }
        }
    }
    
    func _format(_ message: String) -> [String : Any] {
        return ["message" : message]
    }
    
    func _handle(_ event: String, data: MFLJson?) {
        
        switch event {
        case event_messageReceived: if let data = data { _handle(message: data) }
        case event_questionnairesNew: if let data = data { _handle(questionnaire: data) }
        case event_questionnairesDeclined: if let data = data { _handle(declineQuestionnaire: data) }
        case event_newSession: if let data = data { _handle(session: data) }
        case event_groupsList: break
        default: break
        }
    }
    
    func _handle(message json: MFLJson) {
        
        let messageText = json["message"].stringValue
        _sendNotificationIfBookedSession(for: messageText)
        let message = _messageDataStore.message(from: json)
        _messages.append(message)
        _notifyReceived(message)
    }
    
    func _sendNotificationIfBookedSession(for message: String) {
        
        DispatchQueue.global(qos: .background).async {
            if message.contains("A new session has been booked") {
                DispatchQueue.main.async { NotificationCenter.default.post(name: MFLShouldFetchSessionsNotification, object: nil) }
            }
        }
    }
    
    func _handle(questionnaire json: MFLJson) {
        let questionnaire = _questionnaireStore.questionnaire(from: json)
        _notify(received: questionnaire)
        NotificationCenter.default.post(name: MFLDidReceiveQuestionnaire, object: nil)
    }
    
    func _handle(declineQuestionnaire json: MFLJson) {
        let id = json["id"].stringValue
        _questionnaireStore.deleteQuestionnaire(withResponseId: id)
        _notify(declineQuestionnaireWith: id)
        NotificationCenter.default.post(name: MFLTherapistDidCancelQuestionnaire, object: nil)
    }
    
    func _handle(session json: MFLJson) {
        let session = RTCVideoSession(json)
        let userInfo = ["session" : session]
        NotificationCenter.default.post(name: MFLDidReceiveSession, object: nil, userInfo: userInfo)
    }
}

//MARK: - Notifiy Observers
fileprivate extension RTCManager {
    
    func _notifyReceived(_ message: Message) {
        _observers.allObjects.forEach { [unowned self] in
            if let observer = $0 as? RTCManagerObserver {
                observer.rtcManager(self, didReceive: message)
            }
        }
    }
    
    func _notifyReceived(_ messages: [Message]) {
        guard messages.count > 0 else { return }
        _observers.allObjects.forEach { [unowned self] in
            if let observer = $0 as? RTCManagerObserver {
                observer.rtcManager(self, didReceive: messages)
            }
        }
    }
    
    func _notifyStatusChange() {
        _observers.allObjects.forEach { [unowned self] in
            if let observer = $0 as? RTCManagerObserver {
                observer.rtcManager(self, didChangeStatus: self.status)
            }
        }
    }
    
    func _notify(received questionnaire: Questionnaire) {
        _observers.allObjects.forEach { [unowned self] in
            if let observer = $0 as? RTCManagerObserver {
                observer.rtcManager(self, didReceive: questionnaire)
            }
        }
    }
    
    func _notify(declineQuestionnaireWith id: String) {
        _observers.allObjects.forEach { [unowned self] in
            if let observer = $0 as? RTCManagerObserver {
                observer.rtcManager(self, didDeclineQuestionnaireWith: id)
            }
        }
    }
    
    func _notifyReceivedPrevious(_ messages: [Message]) {
        _observers.allObjects.forEach { [unowned self] in
            if let observer = $0 as? RTCManagerObserver {
                observer.rtcManager(self, didReceivePrevious: messages)
            }
        }
    }
}

fileprivate struct RTCVideoSession : Session {
    
    fileprivate let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return dateFormatter
    }()
    
    var id : String
    var title : String
    var startDate : Date
    var endDate : Date
    var teamMemberId : String
    var teamMemberFirstName : String
    var teamMemberLastName : String
    var teamMemberImageUrlString : String
    var isCancelled : Bool
    var messageGroupId : String
}

extension RTCVideoSession {
    init(_ json: MFLJson) {
        id                          = json["id"].stringValue
        title                       = json["title"].stringValue
        startDate                   = dateFormatter.date(from: json["startsAt"].stringValue)!
        endDate                     = dateFormatter.date(from: json["endsAt"].stringValue)!
        teamMemberId                = json["worker"]["id"].stringValue
        teamMemberFirstName         = json["worker"]["firstname"].stringValue
        teamMemberLastName          = json["worker"]["lastname"].stringValue
        teamMemberImageUrlString    = json["worker"]["photo"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? json["worker"]["photo"].stringValue
        isCancelled                 = json["cancelled"].boolValue
        messageGroupId              = json["messageGroupId"].stringValue
    }
}
