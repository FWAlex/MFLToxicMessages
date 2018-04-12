//
//  RegisterInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class RegisterInteractorImplementation: RegisterInteractor {
    
    fileprivate let loginManager : LoginManager
    fileprivate let networkManager : NetworkManager
    fileprivate let userDataStore : UserDataStore
    
    init(networkManager: NetworkManager, loginManager: LoginManager, userDataStore: UserDataStore) {
        self.networkManager = networkManager
        self.loginManager = loginManager
        self.userDataStore = userDataStore
    }
    
    func register(with data: RegisterData, handler: @escaping (RegisterResult) -> Void) {
        loginManager.register(with: data) { result in
            
            switch result {
            case .success(let user): handler(.success(user))
            case .failure(let error): handler(.failure(error))
            }
        }
    }
    
    func sendVerificationEmail(handler: @escaping (Error?) -> Void) {
        
        guard let email = UserDefaults.mfl_email else {
            assertionFailure("The user should be logged in by now")
            return
        }
        
        networkManager.sendVerificationEmail(to: email) { result in
            
            switch result {
            case .success(_): handler(nil)
            case .failure(let error): handler(error)
            }
        }
    }
    
    func updateUserICE(with parentConsentData: ParentConsentData, handler: @escaping (Result<User?>) -> Void) {
        userDataStore.updateUser(ice: UserICE(parentConsentData), handler: handler)
    }
}

fileprivate struct UserICE : ICE {
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let relationship: String
    
    init(_ parentConsentData: ParentConsentData) {
        firstName = parentConsentData.parentFirstName
        lastName = parentConsentData.parentLastName
        phoneNumber = parentConsentData.parentPhoneNumber
        relationship = NSLocalizedString("Parent or guardian", comment: "")
    }
}

