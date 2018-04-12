//
//  FileInteractor.swift
//  Pods
//
//  Created by Marc Blasi on 04/10/2017.
//
//

import Foundation

class StepDetailInteractorImplementation: StepDetailInteractor {
    let dataStore : StageDataStore
    
    init(dataStore : StageDataStore) {
        self.dataStore = dataStore
    }
}
