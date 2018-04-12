//
//  StageDataStoreInterfaces.swift
//  Pods
//
//  Created by Marc Blasi on 22/09/2017.
//
//

import Foundation
import Alamofire

public protocol StageDataStore {
    func fetchLocal()
    func fetchStages() -> [Stage]
}

public protocol StagePersistentStore {
    func stages(from json: MFLJson) -> [Stage]
    func stepServer(from json: MFLJson) -> StageStep
    func step(from json: MFLJson) -> StageStep
    func fetchStages() -> [Stage]
}
