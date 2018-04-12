//
//  RegisterViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import UnderKeyboard
import PKHUD

class RegisterViewController: MFLViewController {
    
    var presenter : RegisterPresenter!
    var style: Style!
    
    fileprivate let logInTextStyle = TextStyle.tinyText
    fileprivate let registerButtonBottomPadding = CGFloat(20.0)
    fileprivate let registerButtonDefaultWidth = CGFloat(200.0)
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: MFLTextFieldView!
    @IBOutlet weak var lastNameTextField: MFLTextFieldView!
    @IBOutlet weak var emailTextField: MFLTextFieldView!
    @IBOutlet weak var passwordTextField: MFLTextFieldView!
    @IBOutlet weak var repeatPasswordTextField: MFLTextFieldView!
    @IBOutlet weak var registerButton: RoundedButton!
    @IBOutlet weak var termsAndConditionsCheckBox: CheckBox!
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    @IBOutlet weak var marketingCheckBox: CheckBox!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginLabel: UILabel!
    
    fileprivate lazy var keyboardObserver: UnderKeyboardObserver = {
        let observer = UnderKeyboardObserver()
        
        observer.animateKeyboard = { [unowned self] height in
            if height > 0 {
                let distance = self.view.height - self.scrollView.frame.maxY
                self.scrollViewBottomConstraint.constant += height - distance
            } else {
                self.scrollViewBottomConstraint.constant = 0
            }
            
            self.view.layoutIfNeeded()
        }
        
        return observer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarStyle = .default
        hidesNavigationBar = true
        
        
        let attributes = [NSForegroundColorAttributeName: style.primary, NSFontAttributeName: UIFont.systemFont(ofSize: 13.0)]
        let attributedString = NSAttributedString(string: "Terms & Conditions", attributes: attributes)
        termsAndConditionsButton.setAttributedTitle(attributedString, for: .normal)
        
        termsAndConditionsCheckBox.boxColor = style.primary
        termsAndConditionsCheckBox.boxTintColor = style.primary
        
        marketingCheckBox.boxColor = style.primary
        marketingCheckBox.boxTintColor = style.primary
        
        logoImageView.image = UIImage(named: "app_logo", in: MFLCommon.shared.appBundle, compatibleWith: nil)
        
        registerButton.backgroundColor = style.primary
        
        let logInAttributedString = presenter.logInText.attributedString(style: logInTextStyle, color: style.textColor2, alignment: .center)
        loginLabel.attributedText = presenter.attributedStringWithLink(from: logInAttributedString, using: style)
        
        setUpTextFields()
        
        keyboardObserver.start()
    }
    
    func setUpTextFields() {
        firstNameTextField.delegate = self
        firstNameTextField.placeholderDefaultColor = style.primary
        firstNameTextField.separatorSuccessColor = style.primary
        firstNameTextField.returnKeyType = .next
        firstNameTextField.textField.addToolBar(backAction: nil,
                                                nextAction: { [weak self] in _ = self?.lastNameTextField.becomeFirstResponder() },
                                                style: style)
        
        lastNameTextField.delegate = self
        lastNameTextField.placeholderDefaultColor = style.primary
        lastNameTextField.separatorSuccessColor = style.primary
        lastNameTextField.returnKeyType = .next
        lastNameTextField.textField.addToolBar(backAction: { [weak self] in _ = self?.firstNameTextField.becomeFirstResponder() },
                                               nextAction: { [weak self] in _ = self?.emailTextField.becomeFirstResponder() },
                                               style: style)
        
        emailTextField.delegate = self
        emailTextField.placeholderDefaultColor = style.primary
        emailTextField.separatorSuccessColor = style.primary
        emailTextField.returnKeyType = .next
        emailTextField.textField.addToolBar(backAction:  { [weak self] in _ = self?.lastNameTextField.becomeFirstResponder() },
                                            nextAction: { [weak self] in _ = self?.passwordTextField.becomeFirstResponder() },
                                            style: style)
        
        passwordTextField.delegate = self
        passwordTextField.placeholderDefaultColor = style.primary
        passwordTextField.separatorSuccessColor = style.primary
        passwordTextField.returnKeyType = .next
        passwordTextField.textField.addToolBar(backAction:  { [weak self] in _ = self?.emailTextField.becomeFirstResponder() },
                                               nextAction: { [weak self] in _ = self?.repeatPasswordTextField.becomeFirstResponder() },
                                               style: style)
        
        repeatPasswordTextField.delegate = self
        repeatPasswordTextField.placeholderDefaultColor = style.primary
        repeatPasswordTextField.separatorSuccessColor = style.primary
        repeatPasswordTextField.returnKeyType = .continue
        repeatPasswordTextField.textField.addToolBar(backAction: { [weak self] in _ = self?.passwordTextField.becomeFirstResponder() },
                                                     style: style)
    }
    
    @IBAction func registerButtonTapped(_ sender: AnyObject) {
        register()
    }

    deinit {
        keyboardObserver.stop()
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        view.endEditing(false)
    }

    @IBAction func agreeToTermsLabelTapped(_ sender: Any) {
        termsAndConditionsCheckBox.isOn = !termsAndConditionsCheckBox.isOn
    }
    
    @IBAction func didTapTermsAndConditions(_ sender: Any) {
        presenter.showTermsAndConditions()
    }
    
    @IBAction func marketingTapped(_ sender: Any) {
        marketingCheckBox.isOn = !marketingCheckBox.isOn
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        presenter.userWantsToLogIn()
    }
}

extension  RegisterViewController : RegisterPresenterDelegate {
    
    func registerPresenterRequestsTypedPassword(_ sender: RegisterPresenter) -> String? {
        return passwordTextField.text
    }
    
    func registerPresenterDidStartLoginProcess(_ sender: RegisterPresenter) {
        
        HUD.show(.progress)
    }
    
    func registerPresenter(_ sender: RegisterPresenter, registerProcessFinishedWith error: Error?) {
        
        HUD.hide()
        
        if let error = error {
            showAlert(for: error)
        }
    }
}

//MARK: - MFLTextFieldViewDelegate
extension RegisterViewController : MFLTextFieldViewDelegate {
    
    func textFieldViewEditingDidBegin(_ sender: MFLTextFieldView) {
        if sender == repeatPasswordTextField {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.scrollToMarketingCheckBox()
            }
        }
    }
    
    func textFieldViewEditingChanged(_ sender: MFLTextFieldView) { /* Empty */ }
    
    func textFieldViewEditingDidEndOnExit(_ sender: MFLTextFieldView) {
        switch sender {
        case firstNameTextField: _ = lastNameTextField.becomeFirstResponder()
        case lastNameTextField: _ = emailTextField.becomeFirstResponder()
        case emailTextField: _ = passwordTextField.becomeFirstResponder()
        case passwordTextField: _ = repeatPasswordTextField.becomeFirstResponder()
        case repeatPasswordTextField: register()
        default: break
        }
    }
    
    func textFieldViewEditingDidEnd(_ sender: MFLTextFieldView) {
        
        if sender === firstNameTextField {
            
            if !mfl_nilOrEmpty(firstNameTextField.text) {
                firstNameTextField.error = presenter.isValid(firstName: firstNameTextField.text)
            } else {
                firstNameTextField.resetToDefaultState()
            }
        }
            
        else if sender === lastNameTextField {
            
            if !mfl_nilOrEmpty(lastNameTextField.text) {
                lastNameTextField.error = presenter.isValid(lastName: lastNameTextField.text)
            } else {
                lastNameTextField.resetToDefaultState()
            }
        }
            
        else if sender === emailTextField {
            
            if !mfl_nilOrEmpty(emailTextField.text) {
                emailTextField.error = presenter.isValid(email: emailTextField.text)
            } else {
                emailTextField.resetToDefaultState()
            }
        }
            
        else if sender === passwordTextField {
            
            if !mfl_nilOrEmpty(passwordTextField.text) {
                passwordTextField.error = presenter.isValid(password: passwordTextField.text)
            } else {
                passwordTextField.resetToDefaultState()
            }
            
            if !mfl_nilOrEmpty(repeatPasswordTextField.text) {
                repeatPasswordTextField.error = presenter.isValid(repeatPassword: repeatPasswordTextField.text)
            }
            
        }
            
        else if sender === repeatPasswordTextField {
            
            if !mfl_nilOrEmpty(repeatPasswordTextField.text) {
                repeatPasswordTextField.error = presenter.isValid(repeatPassword: repeatPasswordTextField.text)
            } else {
                repeatPasswordTextField.resetToDefaultState()
            }
        }
    }
}

//MARK: - Helper
extension RegisterViewController {
    
    func register() {
        view.endEditing(false)
        
        do {
            try presenter.register(firstName: firstNameTextField.text,
                                   lastName: lastNameTextField.text,
                                   email: emailTextField.text,
                                   password: passwordTextField.text,
                                   repeatPassword: repeatPasswordTextField.text,
                                   agreedToTerms: termsAndConditionsCheckBox.isOn,
                                   subscribeMarketing: marketingCheckBox.isOn)
        } catch let error as RegisterError {
            handle(error)
        } catch { }
    }
    
    func handle(_ error: RegisterError) {
        
        error.errors.forEach {
            switch $0 {
            case .firstName(let message): self.firstNameTextField.error = message
            case .lastName(let message): self.lastNameTextField.error = message
            case .email(let message): self.emailTextField.error = message
            case .password(let message): self.passwordTextField.error = message
            case .repeatPassword(let message): self.repeatPasswordTextField.error = message
            case .termsAndConditions(let title, let message): self.showSimpleAlert(title: title, message: message)
            }
        }
    }

    func scrollToMarketingCheckBox() {
        var rect = marketingCheckBox.convert(marketingCheckBox.bounds, to: scrollView)
        rect.size.height += 16 // add some padding
        scrollView.scrollRectToVisible(rect, animated: true)
    }
}

