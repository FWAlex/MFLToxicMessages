//
//  ChangeStageInteractor.swift
//  Pods
//
//  Created by Marc Blasi on 19/09/2017.
//
//

import Foundation

class ChangeStageInteractorImplementation: ChangeStageInteractor {
    let dataStore : StageDataStore
    
    init(dataStore : StageDataStore) {
        self.dataStore = dataStore
    }
    
    func fetchStages() -> [Stage] {
        
        return dataStore.fetchStages()
    }
}
