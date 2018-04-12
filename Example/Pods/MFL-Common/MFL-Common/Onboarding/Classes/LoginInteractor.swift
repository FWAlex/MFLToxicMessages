//
//  LoginInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 20/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import Alamofire

class LoginInteractorImplementation: LoginInteractor {
    
    fileprivate let loginManager : LoginManager
    fileprivate let networkManager : NetworkManager
    
    init(loginManager: LoginManager, networkManager: NetworkManager) {
        self.loginManager = loginManager
        self.networkManager = networkManager
    }
    
    func login(email: String, password: String, handler: @escaping (Result<User>) -> Void) {
        
        loginManager.login(email: email, password: password) { result in
            
            switch result {
            case .success(let user): handler(.success(user))
            case .failure(let error): handler(.failure(error))
            }
        }
    }
    
    func retrievePassword(for email: String, handler: @escaping (Error?) -> Void) {
        
        networkManager.retrievePassword(for: email) {
            
            switch $0 {
            case .success(_): handler(nil)
            
            case .failure(let error):
                if let mfl_Error = error as? MFLError, mfl_Error.displayMessage == "You can't reset this password for this email on this platform" {
                    
                    let errorToSend = MFLError(title: NSLocalizedString("Sorry", comment: ""),
                                               message: NSLocalizedString("The email address you provided is not registered with us. Please try a different email address.", comment: ""))
                    handler(errorToSend)
                }
                else {
                    handler(error)
                }
                
            }
            
        }
        
    }
}
