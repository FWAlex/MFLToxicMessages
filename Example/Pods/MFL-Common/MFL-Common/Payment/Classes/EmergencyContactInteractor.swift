//
//  EmergencyContactInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 28/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import UIKit

class EmergencyContactInteractorImplementation: EmergencyContactInteractor {
    
    fileprivate let userDataStore : UserDataStore
    fileprivate let paymentManager : PaymentManager
    
    typealias Dependencies = HasUserDataStore & HasPaymentManager
    init(_ dependencies: Dependencies) {
        userDataStore = dependencies.userDataStore
        paymentManager = dependencies.paymentManager
    }
    
    var isDeviceSupportingApplePay : Bool {
        return PaymentManager.isDeviceSupportingApplePay
    }
    
    func currentUser() -> User! {
        guard let user = userDataStore.currentUser() else {
            assertionFailure("Should be logged in by now")
            return nil
        }
        
        return user
    }
    
    var hasUserCardSaved : Bool {
        return userDataStore.currentUser()?.card != nil
    }
    
    func updateUser(ice: ICE, handler: @escaping (Error?) -> Void) {
       
        userDataStore.updateUser(ice: ice) {
            switch $0 {
            case .success(_): handler(nil)
            case .failure(let error): handler(error)
            }
        }
    }
    
    func applePay(for payable: Payable, on viewController: UIViewController, completion: @escaping (Error?) -> Void) {
        
        paymentManager.applePay(for: payable, on: viewController) { isCanceled, result in
            
            guard !isCanceled, let result = result else { return }
            
            switch result {
            case .success(_): completion(nil)
            case .failure(let error): completion(error)
            }
        }
    }
    
    func payFor(_ bolton: Bolton, handler: @escaping PaymentManager.CardCompletion) {
        
        guard let cardId = userDataStore.currentUser()?.card?.id else {
            
            let error = MFLError(title: NSLocalizedString("No card available", comment: ""),
                                 message: NSLocalizedString("Could not find any card stored on this account.", comment: ""))
            handler(.failure(error))
            
            return
        }
        
        paymentManager.payFor(bolton, using: cardId, handler: handler)
    }
}
