//
//  ICE.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 17/05/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol ICE : JSONEncodable {
    var firstName : String { get }
    var lastName : String { get }
    var phoneNumber : String { get }
    var relationship : String { get }
}

public extension ICE {
    
    func json() -> [String : Any] {
        
        return [
            "ice" :
                [
                    "phone" : phoneNumber,
                    "firstname" : firstName,
                    "lastname" : lastName,
                    "relationship" : relationship
                ]
            ]
    }
}
