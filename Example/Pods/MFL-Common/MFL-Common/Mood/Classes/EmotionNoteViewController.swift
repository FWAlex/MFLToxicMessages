//
//  EmotionNoteViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import UnderKeyboard
import PKHUD

fileprivate let noteCharacterLimit = 100

class EmotionNoteViewController: MFLViewController {
    
    var presenter : EmotionNotePresenter!
    fileprivate var gradientLayer : CAGradientLayer!
    @IBOutlet fileprivate weak var emotionContainerView: UIView!
    @IBOutlet fileprivate weak var noteTextView: MFLTextView!
    
    fileprivate let addTagsDefaultWidth = CGFloat(200.0)
    fileprivate let addTagsDefaultBotPadding = CGFloat(90.0)
    @IBOutlet fileprivate weak var addTagsButton: RoundedButton!
    @IBOutlet fileprivate weak var addTagsBottomConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var addTagsWidthConstraint: NSLayoutConstraint!
    
    fileprivate lazy var keyboardObserver: UnderKeyboardObserver = {
        let observer = UnderKeyboardObserver()
        
        observer.animateKeyboard = { [unowned self] height in
            if height > 0 {
                self.addTagsBottomConstraint.constant = height
                self.addTagsWidthConstraint.constant = self.view.bounds.width
                self.addTagsButton.cornerRadius = 0.0
            } else {
                self.addTagsBottomConstraint.constant = self.addTagsDefaultBotPadding
                self.addTagsWidthConstraint.constant = self.addTagsDefaultWidth
                self.addTagsButton.cornerRadius = self.addTagsButton.frame.height / 2
            }
            
            self.view.layoutIfNeeded()
        }
        
        return observer
    }()
    
    
    fileprivate lazy var saveBarButton : UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave(_:)))
    }()
    
    fileprivate lazy var closeBarButton : UIBarButtonItem = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        let image = UIImage(named: "close_white", in: Bundle.subspecBundle(named: "Common"), compatibleWith: nil)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeTapped(_:)), for: .touchUpInside)
        button.sizeToFit()
        
        return UIBarButtonItem(customView: button)
    }()
    
    fileprivate var childView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView(_:))))
        
        keyboardObserver.start()
        noteTextView.delegate = self
        noteTextView.textView.autocorrectionType = .default
        noteTextView.maxCharCount = noteCharacterLimit
        
        addTagsButton.setTitleColor(presenter.emotion.buttonTextColor, for: .normal)
        
        navigationItem.leftBarButtonItem = closeBarButton
        navigationItem.rightBarButtonItem = saveBarButton
        
        setUpGradient()
        setUpChildView()
    }
    
    deinit {
        keyboardObserver.stop()
    }
    
    @objc fileprivate func didTapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    func setUpChildView() {
        
        guard let storyboard = storyboard else { return }
    
        let viewController = presenter.emotion.viewController(from: storyboard)
        addChildViewController(viewController)
        
        childView = viewController.view
        childView.translatesAutoresizingMaskIntoConstraints = false
        emotionContainerView.addSubview(childView)
        
        childView.topAnchor.constraint(equalTo: emotionContainerView.topAnchor).isActive = true
        childView.leftAnchor.constraint(equalTo: emotionContainerView.leftAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: emotionContainerView.bottomAnchor).isActive = true
        childView.rightAnchor.constraint(equalTo: emotionContainerView.rightAnchor).isActive = true
    }
    
    
    @objc fileprivate func didTapSave(_ sender: Any) {
        presenter.userWantsToSave(with: note(from: noteTextView.text))
    }
    
    @IBAction func didTapAddTags(_ sender: Any) {
        presenter.userWantsToAddTags(with: note(from: noteTextView.text))
    }
    
    @objc fileprivate func closeTapped(_ sender: Any) {
        presenter.userWantsToCancel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = view.bounds
    }
    
}

//MARK: EmotionNotePresenterDelegate
extension EmotionNoteViewController : EmotionNotePresenterDelegate {
    
    func emotionNotePresenter(_ sender: EmotionNotePresenter, wantsToShowActivity inProgress: Bool) {
        if inProgress { HUD.show(.progress) }
        else { HUD.hide() }
    }
    
    func emotionNotePresenter(_ sender: EmotionNotePresenter, wantsToPresent error: Error) {
        showAlert(for: error)
    }
}

extension EmotionNoteViewController : MFLTextViewDelegate {
    
    func mflTextViewEditingChanged(_ sender: MFLTextView) {
        view.layoutIfNeeded()
    }
}

//MARK: - Helper
fileprivate extension EmotionNoteViewController {
    
    func setUpGradient() {
        gradientLayer = presenter.emotion.gradientLayer()
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func note(from text: String?) -> String? {
        return mfl_nilOrEmpty(text) ? nil : text!
    }
}

fileprivate extension Emotion {
    
    var buttonTextColor : UIColor {
        switch self {
        case .happy: return .mfl_squash
        case .neutral: return .mfl_sea
        case .sad: return .mfl_greyishBrown
        }
    }
    
    func gradientLayer() -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = { () -> [Any] in
            switch self {
            case .happy: return [UIColor.mfl_squash.cgColor, UIColor.mfl_golden.cgColor]
            case .neutral: return [UIColor.mfl_lightBlue.cgColor, UIColor.mfl_sea.cgColor]
            case .sad: return [UIColor.mfl_brownishGrey.cgColor, UIColor.mfl_warmGreyTwo.cgColor]
            }
        }()
        
        return gradientLayer
    }
    
    func viewController(from storyboard: UIStoryboard) -> UIViewController {
        switch self {
        case .happy: return storyboard.instantiateViewController(withIdentifier: EmotionNoteHappyViewController.name)
        case .neutral: return storyboard.instantiateViewController(withIdentifier: EmotionNoteNeutralViewController.name)
        case .sad: return storyboard.instantiateViewController(withIdentifier: EmotionNoteSadViewController.name)
        }
    }
    
}
