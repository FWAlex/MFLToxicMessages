//
//  Card.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 11/05/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol Card {
    var id : String { get }
    var last4Digits : String { get }
    var expMonth : Int { get }
    var expYear : Int { get }
    var address : String { get }
    var postCode : String { get }
}
