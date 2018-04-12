//
//  Package.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import UIKit

public typealias PackageItem = (desc: String, isAvailable: Bool)

public protocol Package : Payable {
    
    var items : [PackageItem] { get }
    var tokensCount : Int { get }
    var durationInterval : Int { get }
    var durationUnit : DurationUnit { get }
}
