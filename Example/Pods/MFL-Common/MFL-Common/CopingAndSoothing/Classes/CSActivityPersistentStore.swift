//
//  CSActivityPersistentStore.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 23/10/2017.
//

import CoreData

class ManagedCSActivityPersistentStore : CSActivityPersistentStore {
    
    fileprivate let moc : NSManagedObjectContext
    
    init(_ dependencies: HasManagedObjectContext) {
        moc = dependencies.moc
    }
    
    func lastUpdatedDate() -> Date? {
        let fetchRequest = ManagedActivityRefresh.request()
        let managedActivityRefresh = moc.contextFetch(fetchRequest)
        return managedActivityRefresh.first?.lastUpdatedDate_
    }
    
    func didUpdateActivities() {
        let fetchRequest = ManagedActivityRefresh.request()
        if let activityRefresh = moc.contextFetch(fetchRequest).first {
            activityRefresh.lastUpdatedDate_ = Date()
        } else {
            let activityRefresh: ManagedActivityRefresh = moc.insertObject()
            activityRefresh.lastUpdatedDate_ = Date()
        }
        
        moc.saveContext()
    }
    
    func fetchActivities() -> [CSActivity] {
        let fetchRequest = ManagedActivity.request()
        return moc.contextFetch(fetchRequest)
    }
    
    func activities(from json: MFLJson) -> [CSActivity] {
        deleteAllActivities()
        moc.saveContext()
        
        var activities = [CSActivity]()
        json.arrayValue.forEach { activities.append(ManagedActivity.object(from: $0, moc: self.moc)) }
        
        return activities
    }
    
    func activity(from json: MFLJson) -> CSActivity {
        let activity = ManagedActivity.object(from: json, moc: self.moc)
        moc.saveContext()
        return activity
    }
    
    fileprivate func deleteAllActivities() {
        let request = ManagedActivity.request() as! NSFetchRequest<NSFetchRequestResult>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try moc.execute(deleteRequest)
        } catch {
            print(error)
        }
    }
    
    func hasUserOpenedFeature() -> Bool {
        let request = ManagedActivityRefresh.request()
        if let object = moc.contextFetch(request).first {
            return object.hasUserOpenedFeature_
        }
        return false
    }
    
    func setUserDidOpenFeature() {
        let request = ManagedActivityRefresh.request()
        if let activityRefresh = moc.contextFetch(request).first {
            activityRefresh.hasUserOpenedFeature_ = true
        } else {
            let activityRefresh: ManagedActivityRefresh = moc.insertObject()
            activityRefresh.hasUserOpenedFeature_ = true
        }
    }
    
    func update(_ activity: CSActivity) {
        if activity is ManagedActivity {
            moc.saveContext()
        }
    }
}
