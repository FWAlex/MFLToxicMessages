//
//  LoginPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 20/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import UIKit

fileprivate let emailEmptyErrorMessage          = NSLocalizedString("Please enter an email", comment: "")
fileprivate let emailInvalidErrorMessage        = NSLocalizedString("The email you have entered is not valid", comment: "")
fileprivate let passwordEmptyErrorMessage       = NSLocalizedString("Please enter a password", comment: "")
fileprivate let passwordInvalidErrorMessage     = NSLocalizedString("The password must have at least 8 characters", comment: "")

fileprivate let signUpInfoText                   = NSLocalizedString("Don't have an account? Sign Up here.", comment: "")
fileprivate let linkRage                        = (signUpInfoText as NSString).range(of: NSLocalizedString("Sign Up here.", comment: ""))
fileprivate let linkID                          = "logInLink_id"

class LoginPresenterImplementation: LoginPresenter {
    
    weak var delegate : LoginPresenterDelegate?
    
    let interactor: LoginInteractor
    let wireframe: LoginWireframe
    
    init(interactor: LoginInteractor, wireframe: LoginWireframe) {
        self.interactor = interactor
        self.wireframe = wireframe
    }
    
    func login(email: String?, password: String?) throws {
        
        let loginData = try extractLoginDataFrom(email: email, password: password)
        
        delegate?.loginPresenter(self, wantsToShowActivity: true)
        
        interactor.login(email: loginData.email, password: loginData.password) { [unowned self] result in
            self.delegate?.loginPresenter(self, wantsToShowActivity: false)
            
            switch result {
                
            case .success(let user):
                self.wireframe.continueJourney(with: user)
                
            case .failure(let error):
                
                var displayError = error
                
                if let mflError = error as? MFLError, mflError.status == .unauthorized {
                    displayError = MFLError(title: NSLocalizedString("Wrong Credentials", comment: ""),
                                            message: NSLocalizedString("The email and password combination you have entered is wrong", comment: ""))
                }
            
                self.delegate?.loginPresenter(self, wantsToShow: displayError)
            }
        }
    }
    
    var signUpText: String {
        return signUpInfoText
    }
    
    func isValid(email: String?) -> String? {
        
        if mfl_nilOrEmpty(email) {
            return emailEmptyErrorMessage
        } else if !Validator.isValid(email: email!) {
            return emailInvalidErrorMessage
        }
        
        return nil
    }
    
    func isValid(password: String?) -> String? {
        
        if mfl_nilOrEmpty(password) {
            return passwordEmptyErrorMessage
        } else if !Validator.isValid(password: password!) {
            return passwordInvalidErrorMessage
        }
        
        return nil
    }
    
    func   attributedStringWithLink(from attrString: NSAttributedString, using style: Style) -> NSAttributedString {
        
        let mutableString = NSMutableAttributedString(attributedString: attrString)
        mutableString.addAttribute(NSLinkAttributeName, value: linkID, range: linkRage)
        mutableString.setColor(style.primary, for: linkRage)
        mutableString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: linkRage)
        mutableString.addAttribute(NSUnderlineColorAttributeName, value: style.primary, range: linkRage)
        
        return mutableString
    }
    
    func userWantsToRetrievePassword(for email: String?) {
        
        guard !showRetrievePasswordAllertIfNecessary(for: email), let email = email else { return }
        
        delegate?.loginPresenter(self, wantsToShowActivity: true)
        
        interactor.retrievePassword(for: email) { [unowned self] error in
            self.delegate?.loginPresenter(self, wantsToShowActivity: false)
            
            if let error = error {
                self.delegate?.loginPresenter(self, wantsToShow: error)
                return
            }
            
            let message = NSLocalizedString("We have send an email to:", comment: "") + "\n\n\(email)\n\n" + NSLocalizedString("Follow the instructions in this email to retrieve your password", comment: "")
            
            let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""),
                                          message:message,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            self.delegate?.loginPresenter(self, wantsToShow: alert)
        }
    }
    
    func userDidSelect(_ url: URL) {
        switch url.absoluteString {
        case linkID: wireframe.presentSignUpPage()
        default: break
        }
    }
}

//MARK: - Helper
fileprivate extension LoginPresenterImplementation {
    
    func extractLoginDataFrom(email: String?, password: String?) throws -> (email: String, password: String) {
        
        var errors = [LoginErrorType]()
        
        if let errorMessage = isValid(email: email) {
            errors.append(.email(errorMessage))
        }
        
        if let errorMessage = isValid(password: password) {
            errors.append(.password(errorMessage))
        }
        
        if errors.count > 0 { throw LoginError(errors: errors) }
        
        return (email!, password!)
    }
    
    /** Returns true if an alert was shown */
    func showRetrievePasswordAllertIfNecessary(for email: String?) -> Bool {
        
        let title = NSLocalizedString("Forgot Password", comment: "")
        var message: String? = nil
        
        if mfl_nilOrEmpty(email) {
            message = NSLocalizedString("Please enter your email address and then tap on \"Forgot Password\".\nWe will send an email with more instructions to the address you provided.", comment: "")
        } else if !Validator.isValid(email: email!) {
            message = NSLocalizedString("The email address you entered seems to not have the valid email format.\nPlease enter a valid email address and then tap on \"Forgot Password\".", comment: "")
        }
        
        guard let alertMessage = message else { return false }
        
        let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        
        delegate?.loginPresenter(self, wantsToShow: alert)
        
        return true
    }
}
