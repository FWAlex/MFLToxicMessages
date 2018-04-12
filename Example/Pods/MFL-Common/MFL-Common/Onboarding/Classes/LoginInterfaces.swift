//
//  LoginInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 20/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

//MARK: - Interactor

public protocol LoginInteractor {
    
    func login(email: String, password: String, handler: @escaping (Result<User>) -> Void)
    func retrievePassword(for email: String, handler: @escaping (Error?) -> Void)
}

//MARK: - Presenter

public protocol LoginPresenterDelegate: class {
    
    func loginPresenter(_ sender: LoginPresenter, wantsToShowActivity inProgress: Bool)
    func loginPresenter(_ sender: LoginPresenter, wantsToShow alert: UIAlertController)
    func loginPresenter(_ sender: LoginPresenter, wantsToShow error: Error)
}

public protocol LoginPresenter {
    
    var signUpText : String { get }
    weak var delegate : LoginPresenterDelegate? { get set }
    func login(email: String?, password: String?) throws
    
    // --- The following will return nil if the validation passes
    // --- or an error string if it fails
    func isValid(email: String?) -> String?
    func isValid(password: String?) -> String?
    // ---
    func attributedStringWithLink(from attrString: NSAttributedString, using style: Style) -> NSAttributedString
    
    func userWantsToRetrievePassword(for email: String?)
    func userDidSelect(_ url: URL)
}

//MARK: - Wireframe

public protocol LoginWireframeDelegate: class {
    
    func loginWireframe(_ sender: LoginWireframe, wantsToContinueJourneyWith user: User)
    func loginWireframeWantsPresentSignUpPage(_ sender: LoginWireframe)
}

public protocol LoginWireframe {
    
    weak var delegate : LoginWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasNetworkManager & HasUserDataStore & HasStyle)
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasNetworkManager & HasUserDataStore & HasStyle, replacingTop: Bool)
    
    func continueJourney(with user: User)
    func presentSignUpPage()
}
