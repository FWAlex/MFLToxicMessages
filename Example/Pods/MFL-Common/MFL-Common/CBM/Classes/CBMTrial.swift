//
//  CBMTrial.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 07/03/2018.
//

import Foundation

enum CBMTrialProbePosition {
    case imageOne
    case imageTwo
}

protocol CBMTrial: JSONEncodable {
    var id : String { get }
    var probePosition : CBMTrialProbePosition { get }
    var imageOneURLString : String { get }
    var imageTwoURLString : String { get }
    var hidePorbeTimestamp : TimeInterval? { get set }
    var userSelectTimestamp : TimeInterval? { get set }
    var userSelectedWrongProbe : Bool? { get set }
    var userFailedToSelect : Bool? { get set }
}

extension CBMTrial {
    func json() -> [String : Any] {
        return ["id" : id,
                "hidePorbeTimestamp" : hidePorbeTimestamp,
                "userSelectTimestamp" : userSelectTimestamp,
                "userSelectedWrongProbe" : userSelectedWrongProbe,
                "userFailedToSelect" : userFailedToSelect]
    }
}
