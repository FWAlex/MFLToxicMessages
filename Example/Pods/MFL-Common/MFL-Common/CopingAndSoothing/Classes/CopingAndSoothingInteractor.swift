//
//  CopingAndSoothingInteractor.swift
//  Pods
//
//  Created by Alex Miculescu on 23/10/2017.
//
//

import Foundation

class CopingAndSoothingInteractorImplementation: CopingAndSoothingInteractor {

    private let activityDataStore : CSActivityDataStore
    init(_ dependencies: HasCSActivityDataStore) {
        activityDataStore = dependencies.csActivityDataStore
    }
    
    func fetchActivities(handler: @escaping (Result<[CSActivity]>) -> Void) {
        activityDataStore.fetchActivities(handler: handler)
    }
    
}
