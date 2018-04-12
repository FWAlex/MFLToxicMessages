//
//  PackageDataStore.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 26/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

fileprivate let packagesRefreshPeriod = TimeInterval(3600 * 24 * 7) // 1 week

class PackageDataStoreImplementation : PackageDataStore {
    
    typealias Dependencies = HasPackagePersistentStore & HasNetworkManager
    
    fileprivate let persistentStore : PackagePersistentStore
    fileprivate let networkManager : NetworkManager
    
    init(_ dependencies: Dependencies) {
        persistentStore = dependencies.packagePersistentStore
        networkManager = dependencies.networkManager
    }
    
    func fetchPackages(handler: @escaping (Result<[Package]>) -> Void) {

        if shouldFetchRemotePackages() {
            fetchRemotePackages(handler: handler)
        } else {
            handler(.success(fetchStoredPackages()))
        }
    }
    
    func package(for id: String, handler: @escaping (Result<Package?>) -> Void) {
        
        if shouldFetchRemotePackages() {
        
            fetchRemotePackages() { [weak self] result in
                
                switch result {
                case .success(_): handler(.success(self?.persistentStore.package(for: id)))
                case .failure(let error):
                    if let package = self?.persistentStore.package(for: id) {
                        handler(.success(package))
                    } else {
                        handler(.failure(error))
                    }
                }
            }
        
        } else {
            return handler(.success(persistentStore.package(for: id)))
        }
    }
    
    fileprivate func shouldFetchRemotePackages() -> Bool {
        return UserDefaults.mfl_packagesRefreshDate < Date()
    }

    fileprivate func fetchRemotePackages(handler: @escaping (Result<[Package]>) -> Void) {
        
        networkManager.fetchPackages {
            
            switch $0 {
            case .success(let json):
                handler(.success(self.persistentStore.packages(from: json["content"])))
                self.updatePackagesRemoteFetchDate()
                
            case .failure(let error):
                print(error)
                handler(.failure(error))
            }
        }
    }
    
    fileprivate func fetchStoredPackages() -> [Package] {
        return persistentStore.fetchPackages()
    }
    
    fileprivate func updatePackagesRemoteFetchDate() {
        UserDefaults.mfl_packagesRefreshDate = Date().addingTimeInterval(packagesRefreshPeriod)
    }
}
