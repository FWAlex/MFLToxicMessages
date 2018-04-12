//
//  User.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 20/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol User {
    var id : String { get }
    var firstName : String { get }
    var lastName : String { get }
    var email : String { get }
    var isVerified : Bool { get }
    var assignedTeamMember : TeamMember { get }
    var userPackage : UserPackage? { get }
    var createdAt : Date { get }
    var card : Card? { get }
    var ice : ICE? { get }
    var sessions : [Session]? { get }
    var hasRequestedTherapist : Bool { get }
    var therapistRequestCount : Int { get }
    var isWaitingForMentorRequestApproval : Bool { get }
}
