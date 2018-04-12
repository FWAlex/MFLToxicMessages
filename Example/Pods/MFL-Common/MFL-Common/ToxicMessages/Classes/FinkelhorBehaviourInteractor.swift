//
//  FinkelhorBehaviourInteractor.swift
//  Pods
//
//  Created by Alex Miculescu on 05/12/2017.
//
//

import Foundation

class FinkelhorBehaviourInteractorImplementation: FinkelhorBehaviourInteractor {
    
    private let finkelhorDataStore : FinkelhorDataStore
    
    init(finkelhorDataStore: FinkelhorDataStore) {
        self.finkelhorDataStore = finkelhorDataStore
    }
    
    func getBehaviours(for category: FinkelhorCategory) -> [FinkelhorBehaviour] {
        return finkelhorDataStore.getBehaviours(for: category)
    }
    
    func save(_ behaviour: FinkelhorBehaviour) {
        finkelhorDataStore.save(behaviour)
    }
    
}
