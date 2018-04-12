//
//  EmergencyContactFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 28/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasEmergencyContactInteractor {
    var emergencyContactInteractor : EmergencyContactInteractor! { get }
}

protocol HasEmergencyContactWireframe {
    var emergencyContactWireframe : EmergencyContactWireframe! { get }
}

class EmergencyContactFactory {
    
    class func wireframe() -> EmergencyContactWireframe {
        return EmergencyContactWireframeImplementation()
    }
    
    class func interactor(_ dependencies: EmergencyContactDependencies) -> EmergencyContactInteractor {
        return EmergencyContactInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: EmergencyContactDependencies) -> EmergencyContactPresenter {
        return EmergencyContactPresenterImplementation(dependencies)
    }
}

struct EmergencyContactDependencies : HasEmergencyContactWireframe, HasEmergencyContactInteractor, HasUserDataStore, HasPaymentManager, HasPayable {
    var emergencyContactInteractor: EmergencyContactInteractor!
    var emergencyContactWireframe: EmergencyContactWireframe!
    var userDataStore: UserDataStore!
    var paymentManager: PaymentManager!
    var payable: Payable!
}
