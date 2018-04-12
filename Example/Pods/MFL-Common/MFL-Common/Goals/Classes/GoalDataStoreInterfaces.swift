//
//  GoalDataStoreInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol GoalDataStore {
    
    func fetchGoals(handler: @escaping (UpdateResult<[Goal]>) -> Void)
    func newGoal(title: String, desc: String, progress: Int, handler: @escaping (Result<Goal>) -> Void)
    func save(_ goal: Goal, handler: @escaping (Result<Goal>) -> Void)
    func delete(_ goal: Goal, handler: @escaping (Result<String>) -> Void)
    func rollback()
}

public protocol GoalPersistentStore {
    
    func goals(from json: MFLJson) -> [Goal]
    func goal(from json: MFLJson) -> Goal
    func save()
    func delete(_ goal: Goal)
    func fetchGoals() -> [Goal]
    func rollback()
}
