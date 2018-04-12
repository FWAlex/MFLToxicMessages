//
//  UserDataStore.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 20/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class UserDataStoreImplementation: UserDataStore {
    
    typealias Dependencies = HasUserPresistentStore & HasNetworkManager
    
    let persistentStore : UserPersistentStore
    let networkManager : NetworkManager
    
    init(_ dependencies: Dependencies) {
        persistentStore = dependencies.userPersistentStore
        networkManager = dependencies.networkManager
    }
    
    func user(from json: MFLJson) -> User? {
        return persistentStore.user(from: json)
    }
    
    func currentUser() -> User? {
        return persistentStore.currentUser()
    }
    
    func save(_ user: User) {
        persistentStore.save(user)
    }
    
    func refreshUserPackages(handler: @escaping (Result<User?>) -> Void) {
        
        networkManager.fetchUserPackages { [weak self] result in
            guard let sself = self else { return }
            sself.updateUserSubscription(result, handler: handler)
        }
    }
    
    func unsubscribe(handler: @escaping (Result<User?>) -> Void) {
        
        networkManager.deleteSubscription() { [weak self] result in
            guard let sself = self else { return }
            sself.updateUserSubscription(result, handler: handler)
        }
    }
    
    func updateToPackage(with id: String, handler: @escaping (Result<User?>) -> Void) {
        
        networkManager.updateToSubscription(with: id) { [weak self] result in
            guard let sself = self else { return }
            sself.updateUserSubscription(result, handler: handler)
        }
    }
    
    fileprivate func updateUserSubscription(_ newtworkResult: Result<MFLJson>, handler: @escaping (Result<User?>) -> Void) {
        switch newtworkResult {
        case .success(let json):
            if json["content"].stringValue == "OK" {
                self.persistentStore.deleteUserPackage()
            } else {
                self.persistentStore.updateUserPackage(form: json["content"])
            }
            
            return handler(.success(self.currentUser()))
            
        case .failure(let error): handler(.failure(error));
            
        }
    }
    
    func update(names: UserDataStoreNameUpdates, handler: @escaping (Result<User?>) -> Void) {
        networkManager.updateUser(firstName: names.firstName, lastName: names.lastName) {
            
            switch $0 {
            case .success(let json):
                if let user = self.user(from: json["content"]) {
                    handler(.success(user))
                } else {
                    handler(.success(nil))
                }
            case .failure(let error): handler(.failure(error))
            }
            
        }
    }
    
    func logOut() {
        persistentStore.deleteCurrentUser()
    }
    
    func fetchUserCard(handler: @escaping (Result<User?>) -> Void) {
        
        networkManager.retrieveStripeCustomer() {
            
            switch $0 {
            case .success(let json):
                
                let customerJson = json["content"]["customer"]
                
                if customerJson.isEmpty {
                    handler(.success(nil))
                } else {
                    handler(.success(self.persistentStore.setUserCard(customerJson: customerJson)))
                }
                
                
            case .failure(let error): handler(.failure(error))
                
            }
            
        }
    }
    
    func updateUser(ice: ICE, handler: @escaping (Result<User?>) -> Void) {
        
        networkManager.updateUser(ice: ice) {
            
            switch $0 {
            case .success(let json): handler(.success(self.persistentStore.updateUserICE(json: json["content"])))
            case .failure(let error): handler(.failure(error))
            }
        }
    }
    
    func fetchTherapistOnlineStatus(handler: @escaping (Result<TherapistOnlineStatus>) -> Void) {
        
        networkManager.assignedTherapist {
            switch $0 {
            case .success(let json):
                if json["content"]["isOOO"].boolValue { handler(.success(.ooo)) }
                else { handler(.success(json["content"]["online"].boolValue ? .online : .offline)) }
            case .failure(let error): handler(.failure(error))
            }
        }
    }
    
    func updateSessions(handler: @escaping (Result<User?>) -> Void) {
        
        networkManager.getSessions() { [unowned self] result in
            
            switch result {
            case .success(let json): handler(.success(self.persistentStore.updateUserWithSessions(from: json["content"])))
            case .failure(let error): handler(.failure(error))
            }
        }
    }
    
    func cancel(_ session: Session, handler: @escaping (Error?) -> Void) {
        
        networkManager.cancel(session) {
            
            switch $0 {
            case .success(_):
                NotificationCenter.default.post(name: MFLShouldFetchSessionsNotification, object: nil)
                handler(nil)
            case .failure(let error): handler(error)
            }
        }
    }
    
    func requestNewTherapist(reason: String?, handler: @escaping (Result<User?>) -> Void) {
        
        networkManager.requestNewTherapist(reason: reason) { [weak self] result in
            
            switch result {
                
            case .success(let json):
                if json["content"].stringValue == "Request Forwarded to the Clinical Team" {
                    self?.refreshUser(handler: handler)
                } else {
                    _ = self?.persistentStore.updateUserAssignedTeamMember(form: json["content"])
                    self?.refreshUser(handler: handler)
                }
                
            case .failure(let error): handler(.failure(error))
            }
        }
    }
    
    func refreshUser(handler: @escaping (Result<User?>) -> Void) {
        
        networkManager.refreshUser() { [weak self] result in
            
            switch result {
                
            case .success(let json):
                let user = self?.persistentStore.user(from: json["content"])
                handler(.success(user))
            
            case .failure(let error): handler(.failure(error))
            }
            
        }
    }
}
