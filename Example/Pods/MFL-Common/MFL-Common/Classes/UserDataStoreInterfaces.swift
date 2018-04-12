//
//  UserDataStoreInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public enum TherapistOnlineStatus {
    case offline
    case online
    case ooo // Out Of Office
}

public protocol UserDataStoreNameUpdates {
    var firstName: String? { get }
    var lastName: String? { get }
}

public protocol UserDataStore {
    func user(from json: MFLJson) -> User?
    func currentUser() -> User?
    func save(_ user: User)
    func refreshUser(handler: @escaping (Result<User?>) -> Void)
    func refreshUserPackages(handler: @escaping (Result<User?>) -> Void)
    func unsubscribe(handler: @escaping (Result<User?>) -> Void)
    func updateToPackage(with id: String, handler: @escaping (Result<User?>) -> Void)
    func update(names: UserDataStoreNameUpdates, handler: @escaping (Result<User?>) -> Void)
    func fetchUserCard(handler: @escaping (Result<User?>) -> Void)
    func logOut()
    func updateUser(ice: ICE, handler: @escaping (Result<User?>) -> Void)
    func fetchTherapistOnlineStatus(handler: @escaping (Result<TherapistOnlineStatus>) -> Void)
    func updateSessions(handler: @escaping (Result<User?>) -> Void)
    func cancel(_ session: Session, handler: @escaping (Error?) -> Void)
    func requestNewTherapist(reason: String?, handler: @escaping (Result<User?>) -> Void)
}

public protocol UserPersistentStore {
    func user(from json: MFLJson) -> User?
    func currentUser() -> User?
    func save(_ user: User)
    func updateUserPackage(form json: MFLJson)
    func deleteUserPackage()
    func deleteCurrentUser()
    func setUserCard(customerJson: MFLJson) -> User?
    func updateUserICE(json: MFLJson) -> User?
    func updateUserWithSessions(from json: MFLJson) -> User?
    func updateUserAssignedTeamMember(form json: MFLJson) -> User?
    func incrementRequestTherapistCount() -> User?
}
