//
//  ReflectionSpaceItemDataStoreInterfaces.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 05/10/2017.
//

import Foundation

protocol ReflectionSpaceItemDataStore {
    func save(_ item: ReflectionSpaceItemType) -> ReflectionSpaceItem
    func getAllItems() -> [ReflectionSpaceItem]
    func delete(_ item: ReflectionSpaceItem)
}

protocol ReflectionSpaceItemPersistentStore {
    func save(_ item: ReflectionSpaceItemType) -> ReflectionSpaceItem
    func getAllItems() -> [ReflectionSpaceItem]
    func delete(_ item: ReflectionSpaceItem)
}

//MARK: - Dependencies
protocol HasReflectionSpaceItemPersistentStore  {
    var reflectionSpaceItemPersistentStore : ReflectionSpaceItemPersistentStore! { get }
}

protocol HasReflectionSpaceItemDataStore {
    var reflectionSpaceItemDataStore : ReflectionSpaceItemDataStore! { get }
}

