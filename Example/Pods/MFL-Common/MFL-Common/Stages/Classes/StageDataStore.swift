//
//  StageDataStore.swift
//  Pods
//
//  Created by Marc Blasi on 22/09/2017.
//
//

import Foundation

class StageDataStoreImplementation: StageDataStore {    
    typealias Dependencies = HasStagePersistentStore & HasNetworkManager
    
    let persistentStore : StagePersistentStore
    let networkManager : NetworkManager
    let localStagesURL: URL
    
    init(_ dependencies: Dependencies, localStagesURL: URL) {
        persistentStore = dependencies.stagePersistentStore
        networkManager = dependencies.networkManager
        self.localStagesURL = localStagesURL
    }
    
    func fetchLocal() {
        do {
            let data = try Data(contentsOf: self.localStagesURL, options: .alwaysMapped)
            let json = MFLDefaultJsonDecoder.json(with: data)
            persistentStore.stages(from: json)
        }
        catch _ {
            
        }
    }
    
    func fetchStages() -> [Stage] {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if version != UserDefaults.mfl_versionDidStagesInstall {
                self.fetchLocal()
                
            }
        }
        
        return persistentStore.fetchStages()
    }
}

