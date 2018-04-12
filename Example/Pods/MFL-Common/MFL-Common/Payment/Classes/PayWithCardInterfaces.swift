//
//  PayWithCardInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 01/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import Stripe

//MARK: - Interactor

protocol PayWithCardInteractor {
    func pay(for payable: Payable, using cardDetails: CardDetails, handler: @escaping (Result<User?>) -> Void)
    func addCard(with cardDetails: CardDetails, handler: @escaping (Result<User?>) -> Void)
}

//MARK: - Presenter

protocol PayWithCardPresenterDelegate : class {
    
    func payWithCardPresenterDidStartPaying(_ sender: PayWithCardPresenter)
    func payWithCardPresenter(_ sender: PayWithCardPresenter, wantsToShow alert: UIAlertController)
    func payWithCardPresenter(_ sender: PayWithCardPresenter, didFinishPayingWith error: Error?)
}

protocol PayWithCardPresenter {
    
    weak var delegate : PayWithCardPresenterDelegate? { get set }
    
    var submitText : String { get }
    
    func isValid(cardDetails: CardDetails) -> String?
    func isValid(address: String?) -> String?
    func isValid(postCode: String?) -> String?
    
    func userWantsToFinishPaymentWith(_ cardDetails: CardDetails) throws
}

//MARK: - Wireframe

protocol PayWithCardWireframeDelegate : class {
    func payWithCardWireframeDidFinish(_ sender: PayWithCardWireframe)
}

protocol PayWithCardWireframe {
    
    weak var delegate : PayWithCardWireframeDelegate? { get set }
    
    // If the payable is nil then this module will just change the user active card
    // If no AlertText is provided, no alert will be showed if the process succeeds
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasUserDataStore & HasStyle, payable: Payable?, alertText: AlertText?) -> UIViewController
    
    func finish()
}
