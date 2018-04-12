//
//  FinkelhorDataStore.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 29/11/2017.
//

import Foundation

class FinkelhorDataStoreImplementation : FinkelhorDataStore {
    
    fileprivate let persistentStore : FinkelhorPersistentStore
    
    init(_ dependencies: HasFinkelhorPersistentStore) {
        persistentStore = dependencies.finkelhorPersistentStore

        loadHardcodedBehavioursIfNeeded()
    }
    
    func loadHardcodedBehavioursIfNeeded() {
        guard !persistentStore.didLoadHardcodedData else { return }
        
        if let path = Bundle.toxicMessages.path(forResource: "FinkelhorBehaviour", ofType: "plist") {
            if let array = NSArray(contentsOfFile: path) as? [Any] {
                let json = MFLDefaultJsonDecoder.json(with: array)
                persistentStore.saveBehaviours(from: json)
                persistentStore.setDidLoadHardcodedData()
            }
        }
    }
    
    func getBehaviours(for category: FinkelhorCategory) -> [FinkelhorBehaviour] {
        return persistentStore.getBehaviours(for: category)
    }
    
    func save(_ behaviour: FinkelhorBehaviour) {
        persistentStore.save(behaviour)
    }
}
