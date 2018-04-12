//
//  RegisterFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

open class RegisterFactory {
    
    open class func wireframe() -> RegisterWireframe {
        return RegisterWireframeImplementation()
    }
    
    class func interactor(networkManager: NetworkManager, loginManager: LoginManager, userDataStore: UserDataStore) -> RegisterInteractor {
        return RegisterInteractorImplementation(networkManager: networkManager, loginManager: loginManager, userDataStore: userDataStore)
    }
    
    class func presenter(interactor: RegisterInteractor, wireframe: RegisterWireframe, parentConsentData: ParentConsentData?, registerData: RegisterData) -> RegisterPresenter {
        return RegisterPresenterImplementation(interactor: interactor, wireframe: wireframe, parentConsentData: parentConsentData, registerData: registerData)
    }
}
