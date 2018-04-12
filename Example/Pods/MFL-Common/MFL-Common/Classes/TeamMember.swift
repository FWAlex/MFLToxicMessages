//
//  TeamMember.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol TeamMember {
    
    var id : String { get }
    var name : String { get }
    var avatarURL : String { get }
    var bio : String { get }
    var jobTitle : String { get }
    var gender : Gender { get }
    var training : String { get }
    var professionalBodies : String { get }
    var isOnline : Bool { get }
}

public func ==(left: TeamMember?, right: TeamMember?) -> Bool {
    
    guard let left = left, let right = right else { return false }
    
    return left.id == right.id
}
