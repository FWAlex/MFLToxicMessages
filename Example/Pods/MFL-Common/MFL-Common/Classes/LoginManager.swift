//
//  LoginManager.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

open class LoginManager {
    
    fileprivate let networkManager : NetworkManager
    fileprivate let userDataStore : UserDataStore
    
    public init(networkManager: NetworkManager, userDataStore: UserDataStore) {
        self.networkManager = networkManager
        self.userDataStore = userDataStore
    }
    
    func login(email: String, password: String, handler: @escaping (Result<User>) -> Void) {
        
        // First log in
        networkManager.login(email: email, password: password) { result in
            
            switch result {
                
            case .success(let json):
                let contentJson = json["content"]
                
                // Save access token and user credentials
                self.extractAccessToken(from: contentJson)
                self.saveLoginCredentials(email: email, password: password)
                
                if let user = self.userDataStore.user(from: contentJson["user"]) {
                    
                    self.userDataStore.save(user)
                    
                    // Refresh the user's subscription
                    self.userDataStore.refreshUserPackages { result in
                        
                        switch result {
                        case .success(let userWithPackage):
                            var newUser: User
                            if userWithPackage != nil {
                                newUser = userWithPackage!
                            } else {
                                newUser = user
                            }
                            
                            // Fetch the user card
                            self.fetchUserCard(newUser, handler: handler)
                            
                        case .failure(_) : handler(.success(user))
                            
                        }
                        
                    }
                    
                } else {
                    
                    handler(.failure(MFLError(status: .noContent)))
                }
                
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    fileprivate func fetchUserCard(_ user: User, handler: @escaping (Result<User>) -> Void) {
        
        userDataStore.fetchUserCard() {
            switch $0 {
            case .success(let newUser):
                if let newUser = newUser { handler(.success(newUser)) }
                else { handler(.success(user)) }

            case .failure(_) : handler(.success(user))
            }
        }
    }
    
    func register(with data: RegisterData, handler: @escaping (Result<User>) -> Void) {
        
        networkManager.register(with: data) { result in
            
            switch result {
                
            case .success(_):
                self.login(email: data.email, password: data.password, handler: handler)
                
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    fileprivate func extractAccessToken(from json: MFLJson) {
        UserDefaults.mfl_accessToken = json["accessToken"].stringValue
        UserDefaults.mfl_accessTokenExpiryTime = TimeInterval(json["expiresInMillisecs"].doubleValue / 1_000)
    }
    
    fileprivate func saveLoginCredentials(email: String, password: String) {
        UserDefaults.mfl_email = email
        UserDefaults.mfl_password = password
    }
}

public struct RegisterData {
    public var firstName = ""
    public var lastName = ""
    public var email = ""
    public var password = ""
    public var gender = Gender.male
    public var dob = Date()
    public var shouldReceivePromotions = false
    
    public init() { /* Empty */ }
}
