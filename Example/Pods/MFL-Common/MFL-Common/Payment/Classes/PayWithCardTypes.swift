//
//  PayWithCardTypes.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/05/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

enum PayWithCardErrorType {
    case cardParams(String?)
    case address(String?)
    case postCode(String?)
}

struct PayWithCardError: Error {
    let errors : [PayWithCardErrorType]
}
