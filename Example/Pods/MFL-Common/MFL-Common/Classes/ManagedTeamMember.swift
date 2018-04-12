//
//  ManagedTeamMember.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import CoreData

final class ManagedTeamMember : ManagedObject, JSONDecodableManagedObject {
    
    @nonobjc public static func request() -> NSFetchRequest<ManagedTeamMember> {
        return NSFetchRequest(entityName: "TeamMember");
    }
    
    @NSManaged public var id_: String
    @NSManaged public var name_: String
    @NSManaged public var avatarURL_ : String
    @NSManaged public var bio_ : String
    @NSManaged public var jobTitle_ : String
    @NSManaged public var gender_ : String
    @NSManaged public var training_ : String
    @NSManaged public var professionalBodies_ : String
    @NSManaged public var isOnline_ : Bool
    
    static func object(from json: MFLJson, moc: NSManagedObjectContext) -> ManagedTeamMember {
        let managedTeamMember: ManagedTeamMember = moc.insertObject()
        
        managedTeamMember.id_ = json["id"].stringValue
        managedTeamMember.name_ = json["firstname"].stringValue
        managedTeamMember.bio_ = json["bio"].stringValue.removeMultileNewLines
        managedTeamMember.jobTitle_ = json["jobTitle"].stringValue.removeMultileNewLines
        managedTeamMember.training_ = json["training"].stringValue.removeMultileNewLines
        managedTeamMember.professionalBodies_ = json["professionalBodies"].stringValue.removeMultileNewLines
        managedTeamMember.avatarURL_ = json["photo"].stringValue
        managedTeamMember.gender_ = json["gender"].stringValue
        managedTeamMember.isOnline_ = json["online"].boolValue
        
        return managedTeamMember
    }
}

extension ManagedTeamMember : TeamMember {
    
    var id : String {
        return id_
    }
    
    var name : String {
        return name_
    }
    
    var avatarURL : String {
        return avatarURL_
    }
    
    var bio : String {
        return bio_
    }
    
    var jobTitle : String {
        return jobTitle_
    }
    
    var gender : Gender {
        let gender = Gender(rawValue: gender_)
        return gender == nil ? .male : gender!
    }
    
    var training : String {
        return training_
    }
    
    var professionalBodies : String {
        return professionalBodies_
    }
    
    var isOnline : Bool {
        return isOnline_
    }
}
