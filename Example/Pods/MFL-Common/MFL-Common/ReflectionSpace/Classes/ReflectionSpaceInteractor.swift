//
//  ReflectionSpaceInteractor.swift
//  Pods
//
//  Created by Alex Miculescu on 03/10/2017.
//
//

import Foundation

class ReflectionSpaceInteractorImplementation: ReflectionSpaceInteractor {
    
    fileprivate let dataStore : ReflectionSpaceItemDataStore
    
    init(_ dependencies: HasReflectionSpaceItemDataStore) {
        dataStore = dependencies.reflectionSpaceItemDataStore
    }
    
    func save(_ item: ReflectionSpaceItemType) -> ReflectionSpaceItem {
        return dataStore.save(item)
    }
    
    func getAllItems() -> [ReflectionSpaceItem] {
        return dataStore.getAllItems()
    }
    
    func delete(_ item: ReflectionSpaceItem) {
        dataStore.delete(item)
    }
}
