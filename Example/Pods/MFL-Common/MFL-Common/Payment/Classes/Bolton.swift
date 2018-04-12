//
//  Bolton.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol Bolton : Payable {
    
    var desc : String { get }
    var tokensCount : Int { get }
    var durationInterval : Int { get }
    var durationUnit : DurationUnit { get }
}

