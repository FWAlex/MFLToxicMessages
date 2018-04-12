//
//  CopingAndSoothingDetailInteractor.swift
//  Pods
//
//  Created by Alex Miculescu on 26/10/2017.
//
//

import Foundation

class CopingAndSoothingDetailInteractorImplementation: CopingAndSoothingDetailInteractor {
    fileprivate let activityDataStore : CSActivityDataStore
    
    init(_ dependencies: HasCSActivityDataStore) {
        activityDataStore = dependencies.csActivityDataStore
    }
    
    func fetchActivities(handler: @escaping (Result<[CSActivity]>) -> Void) {
        activityDataStore.fetchActivities(handler: handler)
    }
    
    func addActivity(with text: String, type: CSActivityType, handler: @escaping (Result<CSActivity>) -> Void) {
        activityDataStore.addActivity(with: text, type: type, handler: handler)
    }
    
    func update(_ activity: CSActivity, handler: @escaping (Error?) -> Void) {
        activityDataStore.update(activity, handler: handler)
    }
}
