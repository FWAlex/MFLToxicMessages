//
//  BoltonsListFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasBoltonsListInteractor {
    var boltonsListInteractor : BoltonsListInteractor! { get }
}

protocol HasBoltonsListWireframe {
    var boltonsListWireframe: BoltonsListWireframe! { get }
}


class BoltonsListFactory {
    
    class func wireframe() -> BoltonsListWireframe {
        return BoltonsListWireframeImplementation()
    }
    
    class func interactor(_ dependencies: BoltonsListDependencies) -> BoltonsListInteractor {
        return BoltonsListInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: BoltonsListDependencies) -> BoltonsListPresenter {
        return BoltonsListPresenterImplementation(dependencies)
    }
}

struct BoltonsListDependencies : HasBoltonsListInteractor, HasBoltonsListWireframe, HasBoltonDataStore {
    var boltonsListWireframe: BoltonsListWireframe!
    var boltonsListInteractor: BoltonsListInteractor!
    var boltonDataStore: BoltonDataStore!
}
