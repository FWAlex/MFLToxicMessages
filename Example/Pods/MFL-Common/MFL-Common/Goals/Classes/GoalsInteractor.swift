//
//  GoalsInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class GoalsInteractorImplementation: GoalsInteractor {
    
    weak var delegate : GoalsInteractorDelegate?
    
    let dataStore : GoalDataStore
    
    init(goalDataStore: GoalDataStore) {
        dataStore = goalDataStore
    }
    
    func fetchGoals(handler: @escaping (UpdateResult<[Goal]>) -> Void) {
        dataStore.fetchGoals(handler: handler)
    }
    
    func delete(_ goal: Goal, handler: @escaping (Result<String>) -> Void) {
        dataStore.delete(goal, handler: handler)
    }
}
