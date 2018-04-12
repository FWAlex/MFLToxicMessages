//
//  ReflectionSpaceItemDataStore.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 05/10/2017.
//

import Foundation

class ReflectionSpaceItemDataStoreImplementation : ReflectionSpaceItemDataStore {
    
    fileprivate var persistentStore : ReflectionSpaceItemPersistentStore
    
    init(_ dependencies: HasReflectionSpaceItemPersistentStore) {
        persistentStore = dependencies.reflectionSpaceItemPersistentStore
    }
    
    func save(_ item: ReflectionSpaceItemType) -> ReflectionSpaceItem {
        return persistentStore.save(item)
    }
    
    func getAllItems() -> [ReflectionSpaceItem] {
        return persistentStore.getAllItems()
    }
    
    func delete(_ item: ReflectionSpaceItem) {
        persistentStore.delete(item)
    }
}

