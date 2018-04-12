//
//  RegisterTypes.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public enum RegisterResult {
    case success(User)
    case failure(Error)
}

enum RegisterErrorType {
    case firstName(String)
    case lastName(String)
    case email(String)
    case password(String)
    case repeatPassword(String)
    case termsAndConditions(title: String, message: String)
}


struct RegisterError : Error {
    let errors : [RegisterErrorType]
}
