//
//  GoalDetailInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class GoalDetailInteractorImplementation: GoalDetailInteractor {
    
    weak var delegate : GoalDetailInteractorDelegate?
    
    let dataStore : GoalDataStore
    
    init(goalDataStore: GoalDataStore) {
        dataStore = goalDataStore
    }
    
    func newGoal(title: String, desc: String, progress: Int, handler: @escaping (Result<Goal>) -> Void) {
        dataStore.newGoal(title: title, desc: desc, progress: progress, handler: handler)
    }
    
    func save(_ goal: Goal, handler: @escaping (Result<Goal>) -> Void) {
        dataStore.save(goal, handler: handler)
    }
    
    func delete(_ goal: Goal, handler: @escaping (Result<String>) -> Void) {
        dataStore.delete(goal, handler: handler)
    }
    
    func rollback() {
        dataStore.rollback()
    }
}
