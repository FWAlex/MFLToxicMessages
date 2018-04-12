//
//  BoltonsListInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import UIKit

class BoltonsListInteractorImplementation: BoltonsListInteractor {
    
    fileprivate let boltonDataStore : BoltonDataStore
    
    typealias Dependencies = HasBoltonDataStore
    init(_ dependencies: Dependencies) {
        boltonDataStore = dependencies.boltonDataStore
    }
    
    func fetchBoltons(handler: @escaping (Result<[Bolton]>) -> Void) {
        boltonDataStore.fetchBoltons(handler: handler)
    }
}
