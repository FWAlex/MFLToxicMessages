//
//  LoginFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 20/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

open class LoginFactory {
    
    class open func wireframe() -> LoginWireframe {
        return LoginWireframeImplementation()
    }
    
    class open func interactor(loginManager: LoginManager, networkManager: NetworkManager) -> LoginInteractor {
        return LoginInteractorImplementation(loginManager: loginManager, networkManager: networkManager)
    }
    
    class open func presenter(interactor: LoginInteractor, wireframe: LoginWireframe) -> LoginPresenter {
        return LoginPresenterImplementation(interactor: interactor, wireframe: wireframe)
    }
}
