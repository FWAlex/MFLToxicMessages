//
//  TeamMemberPersistentStore.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 17/10/2017.
//

import CoreData

class ManagedTeamMemberPersistentStore : TeamMemberPersistentStore {
    
    private let moc : NSManagedObjectContext
    
    init(_ dependencies: HasManagedObjectContext) {
        moc = dependencies.moc
    }
    
    func newTeamMembers(from json: MFLJson) -> [TeamMember] {
        return newTeamMembers(from: json, deleteOld: true)
    }
    
    func newTeamMembers(from json: MFLJson, deleteOld: Bool) -> [TeamMember] {
        
        var teamMembers = [TeamMember]()
        
        if deleteOld {
            deleteStoredTeamMembers()
            moc.saveContext()
        }
        
        moc.saveContext()
        
        json["results"].arrayValue.forEach { jsonTeamMember in
            teamMembers.append(ManagedTeamMember.object(from: jsonTeamMember, moc: moc))
        }
        
        moc.saveContext()
        
        return teamMembers
    }
    
    private func deleteStoredTeamMembers() {
        let request = ManagedTeamMember.request() as! NSFetchRequest<NSFetchRequestResult>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try moc.execute(deleteRequest)
        } catch {
            print(error)
        }
    }
    
    func getStoredTeamMembers() -> [TeamMember] {
        return moc.contextFetch(ManagedTeamMember.request())
    }
}

