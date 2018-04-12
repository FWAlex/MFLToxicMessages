//
//  FinkelhorBehaviour.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 05/12/2017.
//

import Foundation

enum FinkelhorBehaviourSelection {
    case none
    case now
    case past
}

protocol FinkelhorBehaviour {
    var category : FinkelhorCategory { get }
    var section : String { get }
    var selection : FinkelhorBehaviourSelection { get set }
    var text : String { get }
}
