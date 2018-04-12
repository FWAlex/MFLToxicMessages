//
//  CBMLoginViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 07/03/2018.
//
//

import UIKit
import UnderKeyboard
import PKHUD

class CBMLoginViewController: MFLViewController {
    
    var interactor : CBMLoginInteractor!
    var style : Style!
    
    //MARK: - Constatns
    let titleTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 42, weight: UIFontWeightMedium), lineHeight: 42)
    let bodyTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium), lineHeight: 32)
    let placeholderTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium), lineHeight: 32)
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nextButton: RoundedButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //MARK: - Keyboard
    fileprivate lazy var keyboardObserver: UnderKeyboardObserver = {
        let observer = UnderKeyboardObserver()
        
        observer.animateKeyboard = { [unowned self] height in
            if height > 0 {
                self.bottomConstraint.constant = height - self.bottomLayoutGuide.length
            } else {
                self.bottomConstraint.constant = 0.0
            }
            
            self.view.layoutIfNeeded()
        }
        
        return observer
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardObserver.start()
        hidesNavigationBar = true
        applyStyle()
        
        shouldUseGradientBackground = true
        
        setNextButton(isEnabled: false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CBMLoginViewController.didTapView(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        keyboardObserver.stop()
    }
    
    //MARK: - Actions
    @IBAction func nextTapped(_ sender: Any) {
        view.endEditing(true)
        interactor.userWantsToLogin(with: idTextField.text!)
    }
    
    @IBAction func didTapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func idTextFieldEditingChanged(_ sender: Any) {
        if let text = (sender as? UITextField)?.text {
            setNextButton(isEnabled: text.length > 0)
        } else {
            setNextButton(isEnabled: false)
        }
    }
    
    @IBAction func idTextFieldDidEndOnExit(_ sender: Any) {
        if let text = (sender as? UITextField)?.text, text.length > 0 { nextTapped(self) }
    }
    
    
}

//MARK: - CBMLoginPresenterDelegate
extension CBMLoginViewController : CBMLoginPresenterDelegate {
    
    func cbmLoginPresenter(_ sender: CBMLoginPresenter, wantsToPresentActivity inProgress: Bool) {
        if inProgress { HUD.show(.progress) }
        else { HUD.hide() }
    }
    
    func cbmLoginPresenter(_ sender: CBMLoginPresenter, wantsToPresent error: Error) {
        showAlert(for: error)
    }
}

//MARK: - Helper
private extension CBMLoginViewController {
    
    func applyStyle() {
        gradientLayerColors = style.gradient
        
        titleLabel.attributedText = titleTextStyle.attributedString(with: titleLabel.text,
                                                                    color: style.textColor4)
        bodyLabel.attributedText = bodyTextStyle.attributedString(with: bodyLabel.text,
                                                                  color: style.textColor4)
        idTextField.attributedPlaceholder = placeholderTextStyle.attributedString(with: NSLocalizedString("unique identifier", comment: ""),
                                                                                  color: style.textColor4.withAlphaComponent(0.38))
        idTextField.textColor = style.textColor4
        idTextField.tintColor = style.textColor4
    }
    
    func setNextButton(isEnabled: Bool) {
        nextButton.isUserInteractionEnabled = isEnabled
        nextButton.borderColor = isEnabled ? style.textColor4 : style.textColor4.withAlphaComponent(0.5)
        nextButton.backgroundColor = isEnabled ? style.textColor4 : .clear
        nextButton.setTitleColor(isEnabled ? style.primary : style.textColor4.withAlphaComponent(0.5), for: .normal)
    }
}
