//
//  FinkelhorDataStoreInterfaces.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 29/11/2017.
//

import Foundation

protocol HasFinkelhorDataStore {
    var finkelhorDataStore : FinkelhorDataStore! { get }
}

protocol HasFinkelhorPersistentStore {
    var finkelhorPersistentStore : FinkelhorPersistentStore! { get }
}

protocol FinkelhorDataStore {
    func getBehaviours(for category: FinkelhorCategory) -> [FinkelhorBehaviour]
    func save(_ behaviour: FinkelhorBehaviour)
}

protocol FinkelhorPersistentStore {
    var didLoadHardcodedData : Bool { get }
    func setDidLoadHardcodedData()
    func saveBehaviours(from json: MFLJson)
    func getBehaviours() -> [FinkelhorBehaviour]
    func getBehaviours(for category: FinkelhorCategory) -> [FinkelhorBehaviour]
    func save(_ behaviour: FinkelhorBehaviour)
}










