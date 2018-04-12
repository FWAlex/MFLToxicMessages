//
//  Session.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol Session {
    var id : String { get }
    var title : String { get }
    var startDate : Date { get }
    var endDate : Date { get }
    var teamMemberId : String { get }
    var teamMemberFirstName : String { get }
    var teamMemberLastName : String { get }
    var teamMemberImageUrlString : String { get }
    var isCancelled : Bool { get }
    var messageGroupId : String { get }
}
