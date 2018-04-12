//
//  MFLMessagesViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import FW_JSQMessagesViewController

enum MFLMessageType : String {
    case incoming
    case outgoing
}

extension JSQMessage {
    
    var type : MFLMessageType {
        
        if senderId == MFLMessageType.outgoing.rawValue {
            return MFLMessageType.outgoing
        }
        
        return MFLMessageType.incoming
    }
}

class MFLMessagesViewController : JSQMessagesViewController {
    
    var style: Style!
    
    var isInputBarHidden : Bool = false {
        didSet {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    override var showTypingIndicator: Bool {
        didSet {
            if showTypingIndicator {
                //self.collectionView?.contentSize.height += 25
                self.scrollToBottom(animated: true)
            }
        }
    }
    
    fileprivate var messages = [JSQMessage]()
    fileprivate var lastSentMessageIndex = 0
    fileprivate var inputToolbarHeight = CGFloat(44.0)
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    func addIncomingMessage(text: String) {
        addMessage(type: .incoming, name: "", text: text)
    }
    
    func addOutgoingMessage(text: String) {
        addMessage(type: .outgoing, name: "", text: text)
    }
    
    private func addMessage(type: MFLMessageType, name: String, text: String) {
        messages.append(JSQMessage(senderId: type.rawValue, displayName: name, text: text))
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = MFLMessegesLayout()
        layout.mfl_delegate = self
        collectionView?.collectionViewLayout = layout
        
        // No avatars
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        view.backgroundColor = .clear
        collectionView?.backgroundColor = .clear
        collectionView?.clipsToBounds = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isInputBarHidden {
            collectionView?.contentInset.bottom = 0.0
            collectionView?.scrollIndicatorInsets.bottom = 0.0
            inputToolbar.frame = CGRect.zero
        } else {
            inputToolbar.frame = CGRect(x: view.bounds.origin.x,
                                        y: view.bounds.height - inputToolbarHeight,
                                        width: view.bounds.width,
                                        height: inputToolbarHeight)
            collectionView?.contentInset.bottom = inputToolbar.frame.height
            collectionView?.scrollIndicatorInsets.bottom = inputToolbar.frame.height
        }

    }
    
    // MARK: Collection view data source (and related) methods
    override func senderId() -> String {
        return MFLMessageType.outgoing.rawValue
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override public func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource? {
        let message = messages[indexPath.item]
        
        switch message.type {
        case .outgoing: return outgoingBubbleImageView
        case .incoming: return incomingBubbleImageView
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        switch message.type {
        case .outgoing: cell.textView?.textColor = style.textColor1
        case .incoming: cell.textView?.textColor = style.textColor4
        }
        
        return cell
    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        finishSendingMessage(animated: true)
    }
    
    override func finishSendingMessage(animated: Bool) {
        
        if animated {
        
            let indexPaths = insertedMessagesIndexPaths()
            lastSentMessageIndex = messages.count
            
            collectionView?.performBatchUpdates({
                self.collectionView?.insertItems(at: indexPaths)
            }, completion: { _ in
                self.scrollToBottom(animated: true)
            })
            
            let textView = inputToolbar.contentView?.textView
            textView?.text = nil
            textView?.undoManager?.removeAllActions()
            
            NotificationCenter.default.post(name: NSNotification.Name.UITextViewTextDidChange, object: textView)
            
            collectionView?.collectionViewLayout.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext())
            
            self.scrollToBottom(animated: true)
    
        } else {
            super.finishSendingMessage(animated: false)
            lastSentMessageIndex = messages.count
        }
    
    }
    
    
    fileprivate func insertedMessagesIndexPaths() -> [IndexPath] {
        
        var indexPaths = [IndexPath]()
         
        for i in lastSentMessageIndex ..< messages.count {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        
        return indexPaths
    }
    
    // MARK: UI and User Interaction
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory(bubble: UIImage(named: "chat_bot_bubble_outgoing", bundle: .questionnaire)!,
                                                               capInsets: UIEdgeInsets(top: 28, left: 28, bottom: 28, right: 28),
                                                               layoutDirection: .leftToRight)
        return bubbleImageFactory.outgoingMessagesBubbleImage(with: style.textColor3)
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory(bubble: UIImage(named: "chat_bot_bubble_outgoing", bundle: .questionnaire)!,
                                                               capInsets: UIEdgeInsets(top: 28, left: 28, bottom: 28, right: 28),
                                                               layoutDirection: .leftToRight)
        return bubbleImageFactory.incomingMessagesBubbleImage(with: style.textColor2)
    }
}

extension MFLMessagesViewController : MFLMessegesLayoutDelegate {
    
    func mfl_messegesLayout(_ sender: MFLMessegesLayout, typeForItemAt indexPath: IndexPath) -> MFLMessageType {
        return messages[indexPath.row].type
    }
}
