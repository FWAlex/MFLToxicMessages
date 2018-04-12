//
//  RegisterInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit


//MARK: - Interactor

protocol RegisterInteractor {
    
    func register(with data: RegisterData, handler: @escaping (RegisterResult) -> Void)
    func sendVerificationEmail(handler: @escaping (Error?) -> Void)
    func updateUserICE(with parentConsentData: ParentConsentData, handler: @escaping (Result<User?>) -> Void)
}

//MARK: - Presenter

protocol RegisterPresenterDelegate: class {
    func registerPresenterRequestsTypedPassword(_ sender: RegisterPresenter) -> String?
    func registerPresenterDidStartLoginProcess(_ sender: RegisterPresenter)
    func registerPresenter(_ sender: RegisterPresenter, registerProcessFinishedWith error: Error?)
}

protocol RegisterPresenter {
    
    weak var delegate : RegisterPresenterDelegate? { get set }
    
    var logInText : String { get }
    
    func isValid(firstName: String?) -> String?
    func isValid(lastName: String?) -> String?
    func isValid(email: String?) -> String?
    func isValid(password: String?) -> String?
    func isValid(repeatPassword: String?) -> String?
    
    func showTermsAndConditions()
    func register(firstName: String?,
                  lastName: String?,
                  email: String?,
                  password: String?,
                  repeatPassword: String?,
                  agreedToTerms: Bool,
                  subscribeMarketing: Bool) throws
    func attributedStringWithLink(from attrString: NSAttributedString, using style: Style) -> NSAttributedString
    func userWantsToLogIn()
}

//MARK: - Wireframe

public protocol RegisterWireframeDelegate : class {
    
    func registerWireframe(_ sender: RegisterWireframe, wantsToContinueJourneyWith user: User)
    func registerWireframeWantsToShowTermsAndConditions(_ sender: RegisterWireframe)
    func registerWireframeWantsPresentLogInPage(_ sender: RegisterWireframe)
}

public protocol RegisterWireframe {
    
    weak var delegate : RegisterWireframeDelegate? { get set }
    
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasNetworkManager & HasUserDataStore & HasStyle, parentConsentData: ParentConsentData?, registerData: RegisterData)
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasNetworkManager & HasUserDataStore & HasStyle, parentConsentData: ParentConsentData?, registerData: RegisterData, replaceTop: Bool)
    
    func continueJourney(with user: User)
    func showTermsAndConditions()
    func presentLogInPage()
}
