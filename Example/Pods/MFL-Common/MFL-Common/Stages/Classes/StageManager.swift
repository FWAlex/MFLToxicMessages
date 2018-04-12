//
//  StageManager.swift
//  Pods
//
//  Created by Marc Blasi on 22/09/2017.
//
//

import Foundation

public class StageManager {
    
    fileprivate let networkManager : NetworkManager
    fileprivate let stageDataStore : StageDataStore
    
    public init(networkManager: NetworkManager, stageDataStore: StageDataStore) {
        self.networkManager = networkManager
        self.stageDataStore = stageDataStore
    }
    
    func stages(handler: @escaping (Result<[Stage]>) -> Void) {
        
    }
}
