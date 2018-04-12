//
//  CBMSession.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 07/03/2018.
//

import Foundation

protocol CBMSession : JSONEncodable {
    var id : String { get }
    var userId: String { get }
    var kind : String { get }
    var order : Int { get }
    var trials : [CBMTrial] { get }
    var isStarted : Bool { get set }
}

extension CBMSession {
    
    func json() -> [String : Any] {
        let trialsJson: [[String: Any]] = trials.flatMap { (trial) -> [String: Any] in
            return trial.json()
        }
        return ["userId": userId,
                "id": id,
                "data" : trialsJson]
    }
}
