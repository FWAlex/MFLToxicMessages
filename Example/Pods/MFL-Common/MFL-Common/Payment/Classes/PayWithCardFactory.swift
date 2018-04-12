//
//  PayWithCardFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 01/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasPayWithCardInteractor {
    var payWithCardInteractor : PayWithCardInteractor! { get }
}

protocol HasPayWithCardWireframe {
    var payWithCardWireframe : PayWithCardWireframe! { get }
}

class PayWithCardFactory {
    
    class func wireframe() -> PayWithCardWireframe {
        return PayWithCardWireframeImplementation()
    }
    
    class func interactor(_ dependencies: PayWithCardDependencies) -> PayWithCardInteractor {
        return PayWithCardInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: PayWithCardDependencies, payable: Payable?, alertText: AlertText?) -> PayWithCardPresenter {
        return PayWithCardPresenterImplementation(dependencies, payable: payable, alertText: alertText)
    }
}

struct PayWithCardDependencies : HasPayable, HasPayWithCardInteractor, HasPayWithCardWireframe, HasPaymentManager {
    var payable: Payable!
    var payWithCardInteractor: PayWithCardInteractor!
    var payWithCardWireframe: PayWithCardWireframe!
    var paymentManager: PaymentManager!
}
