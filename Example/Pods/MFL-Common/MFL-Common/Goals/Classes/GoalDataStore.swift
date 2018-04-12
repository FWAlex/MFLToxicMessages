//
//  GoalDataStore.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class GoalDataStoreImplementation : GoalDataStore {
    
    let persistentStore : GoalPersistentStore
    let networkManager : NetworkManager
    
    init(_ dependencies: HasNetworkManager & HasGoalPersistentStore) {
        self.persistentStore = dependencies.goalPersistentStore
        self.networkManager = dependencies.networkManager
    }

    func fetchGoals(handler: @escaping (UpdateResult<[Goal]>) -> Void) {
        
        networkManager.fetchUserGoals { result in
            
            switch result {
            case .success(let json):
                var goals = self.persistentStore.goals(from: json["content"])
                if goals.isEmpty { goals = ExampleGoal.goals() }
                handler(.success(goals))
            case .failure(let error):
                let goals = self.persistentStore.fetchGoals()
                handler(.failure(error, goals))
            }
        }
    }
    
    
    func newGoal(title: String, desc: String, progress: Int, handler: @escaping (Result<Goal>) -> Void) {
        
        networkManager.newGoal(title: title, desc: desc, progress: progress) { result in
            
            switch result {
            case .success(let json):
                let goal = self.persistentStore.goal(from: json["content"])
                handler(.success(goal))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func delete(_ goal: Goal, handler: @escaping (Result<String>) -> Void) {
        
        networkManager.deleteGoal(id: goal.id) { [unowned self] result in
            
            switch result {
            case .success:
                self.persistentStore.delete(goal)
                handler(.success("Deleted"))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func save(_ goal: Goal, handler: @escaping (Result<Goal>) -> Void) {
        
        networkManager.updateGoal(goal) { [unowned self] result in
            
            switch result {
            case .success(let json):
                let goal = self.persistentStore.goal(from: json["content"])
                handler(.success(goal))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func rollback() {
        persistentStore.rollback()
    }
}
