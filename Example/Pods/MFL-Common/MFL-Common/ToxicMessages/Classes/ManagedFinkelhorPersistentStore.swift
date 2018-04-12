//
//  ManagedFinkelhorPersistentStore.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 29/11/2017.
//

import CoreData

class ManagedFinkelhorPersistentStore : FinkelhorPersistentStore {

    private let moc : NSManagedObjectContext
    
    init(_ dependencies: HasManagedObjectContext) {
        moc = dependencies.moc
    }
    
    var didLoadHardcodedData : Bool {
        guard let metadata = getMetadata() else { return false }
        return metadata.didLoadHardcodedData
    }
    
    func setDidLoadHardcodedData() {
        var metadata = getMetadata()
        if metadata == nil {
            metadata = moc.insertObject()
        }
        
        metadata?.didLoadHardcodedData = true
        moc.saveContext()
    }
    
    func saveBehaviours(from json: MFLJson) {
        // Delete old if any
        getBehaviours().forEach { if let managedBehaviour = $0 as? ManagedFinkelhorBehaviour { self.moc.delete(managedBehaviour) } }
        moc.saveContext()

        // Create new
        json.arrayValue.forEach { _ = ManagedFinkelhorBehaviour.object(from: $0, moc: self.moc) }
        moc.saveContext()
    }
    
    func getBehaviours() -> [FinkelhorBehaviour] {
        let request = ManagedFinkelhorBehaviour.request()
        return moc.contextFetch(request)
    }
    
    func getBehaviours(for category: FinkelhorCategory) -> [FinkelhorBehaviour] {
        
        let request = ManagedFinkelhorBehaviour.request()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedFinkelhorBehaviour.category_), category.string)
        
        return moc.contextFetch(request)
    }
    
    func save(_ behaviour: FinkelhorBehaviour) {
        moc.saveContext()
    }
    
    private func getMetadata() -> ManagedFinkelhorMetadata? {
        let request = ManagedFinkelhorMetadata.request()
        return moc.contextFetch(request).first
    }
}

fileprivate extension FinkelhorCategory {
    
    var string : String {
        switch self {
        case .traumaticSexualisation: return "traumaticSexualisation"
        case .stigmatisation: return "stigmatisation"
        case .powerlessness: return "powerlessness"
        case .betrayal: return "betrayal"
        }
    }
}
