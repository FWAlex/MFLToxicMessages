//
//  StagesInteractor.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class StagesInteractorImplementation: StagesInteractor {
    fileprivate let userDataStore : UserDataStore
    let dataStore : StageDataStore
    
    typealias Dependencies = HasUserDataStore & HasStageDataStore
    
    init(_ dependencies : Dependencies) {
        self.dataStore = dependencies.stageDataStore
        self.userDataStore = dependencies.userDataStore
    }
    
    func fetchStages() -> [Stage] {
        return dataStore.fetchStages()
    }
    
    func user() -> User {
        return userDataStore.currentUser()!
    }
}

