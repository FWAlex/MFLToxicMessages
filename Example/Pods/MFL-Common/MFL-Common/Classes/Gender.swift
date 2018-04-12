//
//  Gender.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public enum Gender : String {
    case male
    case female
    case agender
    case genderFluid
    
    static let allValues = [Gender.male, .female, .agender, .genderFluid]
}
