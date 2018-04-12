//
//  PayWithCardInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 01/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import Stripe

class PayWithCardInteractorImplementation: PayWithCardInteractor {
    
    fileprivate let paymentManager : PaymentManager
    
    
    typealias Dependencies = HasPaymentManager
    
    init(_ dependencies: Dependencies) {
        paymentManager = dependencies.paymentManager
    }
    
    func pay(for payable: Payable, using cardDetails: CardDetails, handler: @escaping (Result<User?>) -> Void) {
        paymentManager.cardPay(for: payable, using: cardDetails, completion: handler)
    }
    
    func addCard(with cardDetails: CardDetails, handler: @escaping (Result<User?>) -> Void) {
        paymentManager.addCard(with: cardDetails, completion: handler)
    }
}
