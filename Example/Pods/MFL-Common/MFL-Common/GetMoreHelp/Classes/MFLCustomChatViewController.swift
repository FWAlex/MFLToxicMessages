//
//  MFLCustomChatViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 28/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import BABFrameObservingInputAccessoryView

protocol MFLCustomChatViewControllerDelegate : class {
    func customChatViewController(_ sender: MFLCustomChatViewController, wantsToSend message: String)
    func customChatViewControllerWantsToShowPreviousMessages(_ sender: MFLCustomChatViewController)
    func customChatViewControllerWantsToPresentTeam(_ sender: MFLCustomChatViewController)
}

protocol MFLCustomChatViewControllerDataSource : class {
    func customChatViewControllerNumberOfMessages(_ sender: MFLCustomChatViewController) -> Int
    func customChatViewController(_ sender: MFLCustomChatViewController, messageAt index: Int) ->MFLMessage
}

class MFLCustomChatViewController: UIViewController {
    
    weak var delegate : MFLCustomChatViewControllerDelegate?
    weak var dataSource : MFLCustomChatViewControllerDataSource?
    
    var style : Style!
    
    //MARK: - Private Properties
    @IBOutlet fileprivate weak var inputTextView : UITextView!
    @IBOutlet fileprivate weak var bottomConstraint : NSLayoutConstraint!
    @IBOutlet fileprivate weak var chatInputView : UIView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet fileprivate weak var keyboardButtonLeadingConstraint : NSLayoutConstraint!
    @IBOutlet fileprivate weak var keyboardButtonWidthConstraint : NSLayoutConstraint!
    @IBOutlet fileprivate weak var inputTextSeparatorView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet fileprivate weak var hideKeyboardButton : UIButton!
    
    fileprivate var shouldMakeChangesRelatedToKeyboardPosition = false
    fileprivate var didNotifyDelegatePreviousMessages = false
    fileprivate var isUserScrolling             = false
    fileprivate var inputViewYWhenScrolling     = CGFloat(0.0)
    fileprivate var textInputViewMaxHeight      = CGFloat(150.0)
    fileprivate var collectionViewWidth         = CGFloat(0.0)
    fileprivate let verticalContentInset        = CGFloat(16.0)
    fileprivate let keyboardButtonPadding       = CGFloat(8.0)
    fileprivate let animationsDuration          = TimeInterval(0.3)
    fileprivate lazy var bottomInset : CGFloat = {
        return self.chatInputView.frame.height + self.verticalContentInset
    }()
    
    fileprivate let emptyMessage = MFLMessage(text: "", senderName: "", senderPlaceholder: nil, senderImageURL: nil, isOutgoing: false)
    
    fileprivate var messageCount : Int {
        return dataSource?.customChatViewControllerNumberOfMessages(self) ?? 0
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextView.delegate = self
        
        isSendButtonEnabled = false
        
        let inputAccessoryView = BABFrameObservingInputAccessoryView()
        inputAccessoryView.isUserInteractionEnabled = false
        inputTextView.inputAccessoryView = inputAccessoryView
        
        inputAccessoryView.keyboardFrameChangedBlock = { [unowned self]  _, frame in
            
            if let window = UIApplication.shared.mainWindow, self.shouldMakeChangesRelatedToKeyboardPosition {
                var bottomConstraintConstant = self.view.convert(CGPoint.zero, to: window).y
                bottomConstraintConstant += self.view.frame.height
                bottomConstraintConstant -= frame.origin.y
                
                self.bottomConstraint.constant = max(bottomConstraintConstant, 0.0)
                self.view.layoutIfNeeded()
            }
        }
        
        collectionView.collectionViewLayout = MFLCustomChatFlowLayout()
        collectionView.contentInset.top = verticalContentInset
        collectionView.contentInset.bottom = bottomInset
        collectionView.scrollIndicatorInsets.bottom = collectionView.contentInset.bottom
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionViewWidth = collectionView.frame.width
        scrollToBottom(animated: false)
        
        inputViewYWhenScrolling = collectionView.frame.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(MFLCustomChatViewController.keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MFLCustomChatViewController.keyboardDidHide), name: .UIKeyboardDidHide, object: nil)
        
        toggleKeyboardButton(show: false, animated: false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCollectionView))
        collectionView.addGestureRecognizer(tapGesture)
        
        sendButton.setBackgroundImage(UIImage.template(named: "send_message", in: .getMoreHelp) , for: .normal)
        sendButton.tintColor = style.primary
        
        hideKeyboardButton.setBackgroundImage(UIImage(named: "close_keyboard", bundle: .getMoreHelp), for: .normal)
    }
    
    @objc fileprivate func didTapCollectionView(_ sender: Any) {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        shouldMakeChangesRelatedToKeyboardPosition = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        shouldMakeChangesRelatedToKeyboardPosition = false
    }
    
    func reload() {
        self.collectionView.reloadSections(IndexSet(0 ..< 1))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if collectionViewWidth != collectionView.frame.width && messageCount > 0 {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.collectionViewLayout = UICollectionViewFlowLayout()
            
            scrollToBottom(animated: false)
            
            collectionViewWidth = collectionView.frame.width
        }
        
        let contentInset = (collectionView.height - chatInputView.y) + verticalContentInset
        
        if !isUserScrolling {
            
            collectionView.contentInset.bottom = contentInset
            collectionView.scrollIndicatorInsets.bottom = collectionView.contentInset.bottom
            let delta = inputViewYWhenScrolling - chatInputView.frame.origin.y
            var newContentOffset = collectionView.contentOffset.y + delta
            
            collectionView.contentOffset.y = newContentOffset
        }
        
        collectionView.contentInset.top = -(contentInset - chatInputView.height)
    }
    
    //MARK: - Actions
    @IBAction fileprivate func sendTapped(_ sender: Any) {
        
        if let text = inputTextView.text, Validator.isValid(chatMessage: text) {
            delegate?.customChatViewController(self, wantsToSend: text)
        }
        
        inputTextView.isScrollEnabled = false
        inputTextView.text = ""
        view.layoutIfNeeded()
    }
    
    @IBAction func closeKeyboardTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    //MARK: - Exposed
    
    var isSendButtonEnabled : Bool {
        get { return sendButton.isUserInteractionEnabled }
        set {
            sendButton.isUserInteractionEnabled = newValue
            sendButton.alpha = newValue ? 1.0 : 0.50
        }
    }
    
    /**
     Loads messages from the data sourece.
     
     - parameters:
         - count:  Loads this number of messages from the data source. Must be equal to the new number of messages provided by the data sourece.
         - animated:  If the message load should animate or not.
     */
    func gotNewMessage(count: Int = 1, animated: Bool = true, scrollsToBottom: Bool = true) {
        
        var indexPaths = [IndexPath]()
        
        for i in 0..<count {
            indexPaths.append(IndexPath(row: messageCount - (i + 1), section: 0))
        }
        
        if !animated {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
        }
        
        collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: indexPaths)
        }, completion: { [unowned self] _ in
            if scrollsToBottom {
                self.scrollToBottom(animated: animated)
            }
        })
        
        if !animated {
            CATransaction.commit()
        }
    }
    
    func loadPreviousMessages(count: Int) {
        
        var indexPaths = [IndexPath]()
        
        for i in 0..<count {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        
        let bottomOffset = self.collectionView.contentSize.height - self.collectionView.contentOffset.y
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: indexPaths)
        }, completion: { [unowned self] _ in
            self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentSize.height - bottomOffset);
            self.didNotifyDelegatePreviousMessages = false
        })
        
        CATransaction.commit()
    }
    
    func scrollToBottom(animated: Bool) {
        if messageCount > 0 {
            collectionView.scrollToItem(at: IndexPath(row: self.messageCount - 1, section:0),
                                        at: .bottom,
                                        animated: animated)
        }
    }
    
    func setInputView(hidden: Bool, animated: Bool) {
        
        if chatInputView.isHidden == hidden { return }
        
        chatInputView.isHidden = hidden
        
        if animated {
            UIView.animate(withDuration: animationsDuration) {
                self.chatInputView?.alpha = hidden ? 0.0 : 1.0
            }
        }
    }
}

//MARK: - Helper
extension MFLCustomChatViewController {
    
    @objc fileprivate func keyboardDidShow() {
        UIView.animate(withDuration: animationsDuration) { [unowned self] in
            let contentInset = (self.view.height - self.chatInputView.y) + self.verticalContentInset
            self.collectionView.contentInset.top = -(contentInset - self.chatInputView.height)
            self.collectionView.contentInset.bottom = contentInset
            self.collectionView.scrollIndicatorInsets.bottom = self.collectionView.contentInset.bottom
            self.view.layoutIfNeeded()
        }
        
        toggleKeyboardButton(show: true, animated: true)
    }
    
    @objc fileprivate func keyboardDidHide() {
        toggleKeyboardButton(show: false, animated: true)
    }
    
    fileprivate func toggleKeyboardButton(show: Bool, animated: Bool) {
        
        let closure: () -> Void = {
            self.keyboardButtonLeadingConstraint.constant = show ? self.keyboardButtonPadding : -self.keyboardButtonWidthConstraint.constant
            self.inputTextSeparatorView.alpha = show ? 1.0 : 0.0
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: animationsDuration, animations: closure)
        } else {
            closure()
        }
    }
    
    fileprivate func message(at index: Int) -> MFLMessage {
        return dataSource?.customChatViewController(self, messageAt: index) ?? emptyMessage
    }
}

extension MFLCustomChatViewController : UITextViewDelegate {
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let fullText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        var height = fullText.height(constraintTo: textView.frame.width, font: textView.font!)
        height += textView.textContainerInset.top + textView.textContainerInset.bottom
        
        if height < textInputViewMaxHeight {
            textView.isScrollEnabled = false
        } else {
            textView.isScrollEnabled = true
        }
        
        view.layoutIfNeeded()
        
        return true
    }
}

extension MFLCustomChatViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! MFLCustomChatCell
        cell.message = message(at: indexPath.row)
        if cell.style == nil {
            cell.style = style
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: MFLCustomChatHeaderView.identifier,
                                                                         for: indexPath) as! MFLCustomChatHeaderView
        if headerView.style == nil { headerView.style = style }
        headerView.delegate = self
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.width
        let height = collectionView.height - chatInputView.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        
        return CGSize(width: width, height: MFLCustomChatCell.heightFor(message(at: indexPath.row).text, width: width))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        inputViewYWhenScrolling = chatInputView.frame.origin.y
        
        if scrollView.contentOffset.y < 0.0 &&
            scrollView.isTracking &&
            !didNotifyDelegatePreviousMessages {
            
            delegate?.customChatViewControllerWantsToShowPreviousMessages(self)
            didNotifyDelegatePreviousMessages = true
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserScrolling = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isUserScrolling = false
    }
}

extension MFLCustomChatViewController : MFLCustomChatHeaderViewDelegate {
    func mflCustomChatHeaderViewWantsToPresentTeam(_ sender: MFLCustomChatHeaderView) {
        delegate?.customChatViewControllerWantsToPresentTeam(self)
    }
}

fileprivate extension UICollectionView {
    var maxOffsetY : CGFloat {
        let fullContentHeight = contentSize.height + contentInset.top + contentInset.bottom
        return max(fullContentHeight - frame.height, -contentInset.top)
    }
    
    var minOffsetY : CGFloat {
        return -contentInset.top
    }
}

