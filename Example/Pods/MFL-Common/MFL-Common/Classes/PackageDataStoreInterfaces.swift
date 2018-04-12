//
//  PackageDataStoreInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 26/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public func mfl_packageDataStore(with dependencies: HasNetworkManager & HasPackagePersistentStore) -> PackageDataStore {
    return PackageDataStoreImplementation(dependencies)
}

public func mfl_packageDataStore(with networkManager: NetworkManager, and persistentStore: PackagePersistentStore) -> PackageDataStore {
    
    struct Dependencies : HasNetworkManager, HasPackagePersistentStore {
        var networkManager: NetworkManager!
        var packagePersistentStore: PackagePersistentStore!
    }
    
    return PackageDataStoreImplementation(Dependencies(networkManager: networkManager, packagePersistentStore: persistentStore))
}

public protocol PackageDataStore {
    func fetchPackages(handler: @escaping (Result<[Package]>) -> Void)
    func package(for id: String, handler: @escaping (Result<Package?>) -> Void)
}

public protocol PackagePersistentStore {
    func packages(from json: MFLJson) -> [Package]
    func fetchPackages() -> [Package]
    func package(for id: String) -> Package?
}
