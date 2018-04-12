//
//  CBMDataStoreInterfaces.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 06/03/2018.
//

import Foundation

protocol HasCBMDataStore {
    var cbmDataStore: CBMDataStore! { get }
}

protocol HasCBMPersistentStore {
    var cbmPersistentStore : CBMPersistentStore! { get }
}

protocol CBMDataStore {
    func fetchCBMSessions(for userId: String, handler: @escaping (Result<[CBMSession]>) -> Void)
    func finishSession(_ id: String)
}

protocol CBMPersistentStore {
    func sessions(from json: MFLJson, for userId: String) -> [CBMSession]
    func getSessions(for userId: String) -> [CBMSession]
    func getStartedSession() -> CBMSession?
    func markSessiosnWithId(session id: String, asDone done: Bool)
    func save(_ session: CBMSession)
    func save()
}
