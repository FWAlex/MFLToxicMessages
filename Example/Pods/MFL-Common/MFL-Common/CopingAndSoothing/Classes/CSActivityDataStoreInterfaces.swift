//
//  CSActivityDataStoreInterfaces.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 23/10/2017.
//


protocol HasCSActivityDataStore {
    var csActivityDataStore : CSActivityDataStore! { get }
}

protocol HasCSActivityPersistentStore {
    var csActivityPersistentStore : CSActivityPersistentStore! { get }
}

protocol CSActivityDataStore {
    func fetchActivities(handler: @escaping (Result<[CSActivity]>) -> Void)
    func hasUserOpenedFeature() -> Bool
    func setUserDidOpenFeature()
    func addActivity(with text: String, type: CSActivityType, handler: @escaping (Result<CSActivity>) -> Void)
    func update(_ activity: CSActivity, handler: @escaping (Error?) -> Void)
}

protocol CSActivityPersistentStore {
    func activities(from json: MFLJson) -> [CSActivity]
    func activity(from json: MFLJson) -> CSActivity
    func fetchActivities() -> [CSActivity]
    func lastUpdatedDate() -> Date?
    func didUpdateActivities()
    func hasUserOpenedFeature() -> Bool
    func setUserDidOpenFeature()
    func update(_ activity: CSActivity)
}
