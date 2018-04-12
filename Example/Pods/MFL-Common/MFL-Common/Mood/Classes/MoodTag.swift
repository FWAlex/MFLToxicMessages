//
//  MoodTag.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 04/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol MoodTag {
    
    var id : String { get }
    var name : String { get }
    var isPositive : Bool { get }
}
