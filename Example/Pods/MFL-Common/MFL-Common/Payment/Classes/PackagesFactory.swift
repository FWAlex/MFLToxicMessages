//
//  PackagesFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasPackagesWireframe {
    var packagesWireframe : PackagesWireframe! { get }
}

protocol HasPackagesInteractor {
    var packagesInteractor : PackagesInteractor! { get }
}

class PackagesFactory {
    
    class func wireframe() -> PackagesWireframe {
        return PackagesWireframeImplementation()
    }
    
    class func interactor(_ dependencies: PackagesDependencies) -> PackagesInteractor {
        return PackagesInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: PackagesDependencies, currentPackageId: String?) -> PackagesPresenter {
        return PackagesPresenterImplementation(dependencies, currentPackageId: currentPackageId)
    }
}

struct PackagesDependencies : HasPackageDataStore, HasPackagesInteractor, HasPackagesWireframe, HasPaymentManager {
    
    var packageDataStore: PackageDataStore!
    var packagesInteractor: PackagesInteractor!
    var packagesWireframe: PackagesWireframe!
    var paymentManager: PaymentManager!
}
