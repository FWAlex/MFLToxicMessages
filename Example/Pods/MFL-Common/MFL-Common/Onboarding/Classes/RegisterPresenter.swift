//
//  RegisterPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

fileprivate let firstNameEmptyErrorMessage      = NSLocalizedString("Please enter your first name", comment: "")
fileprivate let lastNameEmptyErrorMessage       = NSLocalizedString("Please enter your last name", comment: "")
fileprivate let emailEmptyErrorMessage          = NSLocalizedString("Please enter an email", comment: "")
fileprivate let emailInvalidErrorMessage        = NSLocalizedString("The email you have entered is not valid", comment: "")
fileprivate let passwordEmptyErrorMessage       = NSLocalizedString("Please enter a password", comment: "")
fileprivate let passwordInvalidErrorMessage     = NSLocalizedString("Password must be 8 to 24 characters long", comment: "")
fileprivate let repeatEmptyErrorMessage         = NSLocalizedString("Please retype your password", comment: "")
fileprivate let repeatNoMatchErrorMessage       = NSLocalizedString("Passwords do not match", comment: "")
fileprivate let repeatNoPasswordErrorMessage    = NSLocalizedString("You must type a password first", comment: "")

fileprivate let logInInfoText                   = NSLocalizedString("If you have created an account with another Minds of Life app, Sign in here.", comment: "")
fileprivate let linkRage                        = (logInInfoText as NSString).range(of: NSLocalizedString("Sign in here.", comment: ""))



class RegisterPresenterImplementation : RegisterPresenter {
    
    weak var delegate : RegisterPresenterDelegate?
    fileprivate let interactor : RegisterInteractor
    fileprivate let wireframe : RegisterWireframe
    fileprivate let parentConsentData : ParentConsentData?
    fileprivate var registerData: RegisterData
    
    init(interactor: RegisterInteractor, wireframe: RegisterWireframe, parentConsentData: ParentConsentData?, registerData: RegisterData) {
        self.interactor = interactor
        self.wireframe = wireframe
        self.parentConsentData = parentConsentData
        self.registerData = registerData
    }
    
    var logInText : String {
        return logInInfoText
    }
    
    func register(firstName: String?,
                  lastName: String?,
                  email: String?,
                  password: String?,
                  repeatPassword: String?,
                  agreedToTerms: Bool,
                  subscribeMarketing: Bool) throws {
        
        MFLAnalytics.record(event: .buttonTap(name: "Create Account Tapped", value: nil))
        
        try extractData(firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password,
                        repeatPassword: repeatPassword,
                        agreedToTerms: agreedToTerms)
        
        registerData.shouldReceivePromotions = subscribeMarketing
        
        delegate?.registerPresenterDidStartLoginProcess(self)
        
        // User the email as both email and username
        interactor.register(with: registerData) { [unowned self] result in
            
            switch result {
                
            case .success(let user):
                MFLAnalytics.record(event: .thresholdPassed(name: "Account Created"))
                self.submitParentConsentDataIfNeeded(with: user)
                
            case .failure(let error):
                self.display(error)
            }
        }
    }
    
    fileprivate func submitParentConsentDataIfNeeded(with user: User) {
        
        guard let parentConsentData = parentConsentData else {
            delegate?.registerPresenter(self, registerProcessFinishedWith: nil)
            wireframe.continueJourney(with: user)
            return
        }
        
        interactor.updateUserICE(with: parentConsentData) { [unowned self] result in
            self.delegate?.registerPresenter(self, registerProcessFinishedWith: nil)
            
            switch result {
            case .success(let newUser):
                if let newUser = newUser { self.wireframe.continueJourney(with: newUser) }
                else { self.wireframe.continueJourney(with: user) }
                
                // We are not going to block the user if the ICE data update failed
            // so in case of failure just continue
            case .failure(_): self.wireframe.continueJourney(with: user)
            }
            
        }
    }
    
    func isValid(firstName: String?) -> String? {
        if mfl_nilOrEmpty(firstName) {
            return firstNameEmptyErrorMessage
        }
        
        return nil
    }
    
    func isValid(lastName: String?) -> String? {
        if mfl_nilOrEmpty(lastName) {
            return lastName
        }
        
        return nil
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
    
    func isValid(repeatPassword: String?) -> String? {
        if mfl_nilOrEmpty(repeatPassword) {
            return repeatEmptyErrorMessage
        }
        
        let typedPassword = delegate?.registerPresenterRequestsTypedPassword(self)
        
        if mfl_nilOrEmpty(typedPassword) {
            return repeatNoPasswordErrorMessage
        } else if repeatPassword != typedPassword {
            return repeatNoMatchErrorMessage
        }
        
        return nil
    }
    
    func attributedStringWithLink(from attrString: NSAttributedString, using style: Style) -> NSAttributedString {
        
        let mutableString = NSMutableAttributedString(attributedString: attrString)
        mutableString.setColor(style.primary, for: linkRage)
        mutableString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: linkRage)
        mutableString.addAttribute(NSUnderlineColorAttributeName, value: style.primary, range: linkRage)
        
        return mutableString
    }
    
    fileprivate func extractData(firstName: String?,
                                 lastName: String?,
                                 email: String?,
                                 password: String?,
                                 repeatPassword: String?,
                                 agreedToTerms: Bool) throws {
        
        var errors = [RegisterErrorType]()
        
        if let errorMessage = isValid(firstName: firstName) {
            errors.append(.firstName(errorMessage))
        }
        
        if let errorMessage = isValid(lastName: lastName) {
            errors.append(.firstName(errorMessage))
        }
        
        if let errorMessage = isValid(email: email) {
            errors.append(.email(errorMessage))
        }
        
        if let errorMessage = isValid(password: password) {
            errors.append(.password(errorMessage))
        }
        
        if let errorMessage = isValid(repeatPassword: repeatPassword) {
            errors.append(.repeatPassword(errorMessage))
        }
        
        
        if !agreedToTerms {
            
            errors.append(.termsAndConditions(title: NSLocalizedString("Terms and Conditions", comment: ""),
                                              message: NSLocalizedString("You must agree to the Terms and Conditions before continuing.", comment: "")))
        }
        
        if errors.count > 0 { throw RegisterError(errors: errors) }
        
        registerData.firstName = firstName!
        registerData.lastName = lastName!
        registerData.email = email!
        registerData.password = password!
    }
    
    func showTermsAndConditions() {
        wireframe.showTermsAndConditions()
    }
    
    func userWantsToLogIn() {
        wireframe.presentLogInPage()
    }
}

//MARK: - Helper
extension RegisterPresenterImplementation {
    
    fileprivate func display(_ error: Error) {
        var displayError = error
        
        if let mflError = error as? MFLError,
            mflError.type == .invalidRegistrationEmail {
            
            displayError = MFLError(title: NSLocalizedString("Oops", comment: ""),
                                    message: NSLocalizedString("The email you have entered seems to already be registered with us. Please try to log in instead or try a different email.", comment: ""))
        }
        
        self.delegate?.registerPresenter(self, registerProcessFinishedWith: displayError)
    }
}
