//
//  ReflectionSpaceItemPersistentStore.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 05/10/2017.
//

import CoreData

class ManagedReflectionSpaceItemPersistentStore : ReflectionSpaceItemPersistentStore {
    
    fileprivate let moc : NSManagedObjectContext
    
    init(_ dependencies: HasManagedObjectContext) {
        moc = dependencies.moc
    }
    
    func save(_ item: ReflectionSpaceItemType) -> ReflectionSpaceItem {
        var managedItem: ManagedReflectionSpaceItem
        
        switch item {
        case .image(let name, let thumbName): managedItem = ManagedReflectionSpaceItem.save(name: name, thumb: thumbName, as: .image, in: moc)
        case .video(let name, let thumbName): managedItem = ManagedReflectionSpaceItem.save(name: name, thumb: thumbName, as: .video, in: moc)
        }
        
        moc.saveContext()
        return managedItem
    }
    
    func getAllItems() -> [ReflectionSpaceItem] {
        let request = ManagedReflectionSpaceItem.request()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(ManagedReflectionSpaceItem.date_), ascending: true)]
        return moc.contextFetch(request)
    }
    
    func delete(_ item: ReflectionSpaceItem) {
        guard let item = item as? ManagedReflectionSpaceItem else { return }
        moc.delete(item)
        moc.saveContext()
    }
}


