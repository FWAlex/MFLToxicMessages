//
//  Message.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 27/01/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol Message {
    var id : String { get }
    var senderId : String { get }
    var senderName : String { get }
    var text : String { get }
    var isSent : Bool? { get }
    var sentAt : Date? { get }
    var imageUrlString : String? { get }
}
