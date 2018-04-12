//
//  TeamMamberDataStoreInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasTeamMemberDataStore {
    var teamMemberDataStore : TeamMemberDataStore! { get }
}

protocol HasTeamMemberPersistentStore {
    var teamMemberPersistentStore : TeamMemberPersistentStore! { get }
}

// MARK: - Data Store
protocol TeamMemberDataStore {
    func fetchTeamMembers(forced: Bool, handler: @escaping ([TeamMember]) -> Void)
}

// MARK: - TeamMemberPersistentStore
protocol TeamMemberPersistentStore {
    
    /**
     Creates and saves new team members. Implicitly deletes currently stored team Members.
     
     - parameters:
     - from: A JSON object containing the serialized team members.
     
     - returns: An array of team members.
     */
    func newTeamMembers(from json: MFLJson) -> [TeamMember]
    
    /**
     Creates and saves new team members. Implicitly deletes currently stored team Members.
     
     - parameters:
     - from: A JSON object containing the serialized team members.
     - deleteOld: If true the stored team members are deleted. Else
     the new members are stored along side the old ones.
     
     - returns: An array of team members.
     */
    func newTeamMembers(from json: MFLJson, deleteOld: Bool) -> [TeamMember]
    
    func getStoredTeamMembers() -> [TeamMember]
}
