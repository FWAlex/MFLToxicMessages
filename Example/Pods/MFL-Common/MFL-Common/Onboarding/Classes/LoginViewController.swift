//
//  LoginViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 20/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD
import UnderKeyboard
import AVFoundation

class LoginViewController: MFLViewController {
    
    var presenter : LoginPresenter!
    var style: Style!
    
    fileprivate let signUpTextStyle = TextStyle.tinyText
    fileprivate let loginButtonBottomPadding = CGFloat(16.0)
    fileprivate let loginButtonDefaultWidth = CGFloat(200.0)
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginButton: RoundedButton!
    @IBOutlet weak var forgotPasswordButton: RoundedButton!
    @IBOutlet weak var loginButtonBotConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: MFLTextFieldView!
    @IBOutlet weak var passwordTextField: MFLTextFieldView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signUpTextView: UITextView!
    
    fileprivate lazy var keyboardObserver: UnderKeyboardObserver = {
        let observer = UnderKeyboardObserver()
        
        observer.animateKeyboard = { [unowned self] height in
            if height > 0 {
                let distance = self.containerView.height - self.loginButton.frame.maxY
                self.loginButtonBotConstraint.constant += (height - distance)
                self.loginButtonWidthConstraint.constant = self.view.bounds.width
                self.loginButton.cornerRadius = 0.0
            } else {
                self.loginButtonBotConstraint.constant = self.loginButtonBottomPadding
                self.loginButtonWidthConstraint.constant = self.loginButtonDefaultWidth
                self.loginButton.cornerRadius = self.loginButton.frame.height / 2
            }
            
            self.view.layoutIfNeeded()
        }
        
        return observer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesNavigationBar = true
        
        keyboardObserver.start()
        statusBarStyle = .default
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .continue
        
        emailTextField.placeholderDefaultColor = self.style.primary
        emailTextField.separatorSuccessColor = self.style.primary
        passwordTextField.placeholderDefaultColor = self.style.primary
        passwordTextField.separatorSuccessColor = self.style.primary
        
        loginButton.backgroundColor = self.style.primary
        forgotPasswordButton.setTitleColor(self.style.primary, for: .normal)
        
        logoImageView.image = UIImage(named: "app_logo", in: MFLCommon.shared.appBundle, compatibleWith: nil)
        
        let signUpAttributedString = presenter.signUpText.attributedString(style: signUpTextStyle, color: style.textColor2, alignment: .center)
        signUpTextView.attributedText = presenter.attributedStringWithLink(from: signUpAttributedString, using: style)
    }
    
    deinit {
        keyboardObserver.stop()
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        logIn()
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        view.endEditing(false)
    }
    
    fileprivate func logIn() {
        view.endEditing(false)
        
        do {
            try presenter.login(email: emailTextField.text, password: passwordTextField.text)
        } catch let error as LoginError {
            handle(error)
        } catch { /* Empty */ }
    }
    
    fileprivate func handle(_ error: LoginError) {
        
        error.errors.forEach {
            switch $0 {
            case .email(let errorMessage): self.emailTextField.error = errorMessage
            case .password(let errorMessage): self.passwordTextField.error = errorMessage
            }
        }
    }
    
    @IBAction fileprivate func forgotPasswordTapped(_ sender: Any) {
        presenter.userWantsToRetrievePassword(for: emailTextField.text)
    }
}

extension LoginViewController : LoginPresenterDelegate {
    
    func loginPresenter(_ sender: LoginPresenter, wantsToShowActivity inProgress: Bool) {
        if inProgress { HUD.show(.progress) }
        else { HUD.hide() }
    }
    
    func loginPresenter(_ sender: LoginPresenter, wantsToShow alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func loginPresenter(_ sender: LoginPresenter, wantsToShow error: Error) {
        showAlert(for: error)
    }
    
}

//MARK: - MFLTextFieldViewDelegate
extension LoginViewController : MFLTextFieldViewDelegate {
    
    func textFieldViewEditingDidBegin(_ sender: MFLTextFieldView) { /* Empty */ }
    func textFieldViewEditingChanged(_ sender: MFLTextFieldView) { /* Empty */ }
    
    func textFieldViewEditingDidEndOnExit(_ sender: MFLTextFieldView) {
        
        if sender === emailTextField {
            _ = passwordTextField.becomeFirstResponder()
        } else {
            logIn()
        }
    }
    
    func textFieldViewEditingDidEnd(_ sender: MFLTextFieldView) {
        
        if sender === emailTextField {
            
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
        }
        
    }
    
}

//MARK: - UITextFieldDelegate
extension LoginViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        presenter.userDidSelect(URL)
        return false
    }
}



