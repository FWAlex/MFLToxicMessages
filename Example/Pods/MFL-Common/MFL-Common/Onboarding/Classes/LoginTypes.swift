//
//  LoginTypes.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 21/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

enum LoginErrorType {
    case email(String)
    case password(String)
}

struct LoginError: Error {
    let errors : [LoginErrorType]
}
