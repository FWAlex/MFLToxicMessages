//
//  EmergencyContactTypes.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 28/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

struct EmergencyContactData {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var relationship: String
}

enum EmergencyContactErrorType: Error {
    case phoneNumber(String)
    case firstName(String)
    case lastName(String)
    case relationship(String)
}

struct EmergencyContactError : Error {
    let errors : [EmergencyContactErrorType]
}
