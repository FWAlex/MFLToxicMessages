//
//  BoltonDataStoreInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol BoltonDataStore {
    func fetchBoltons(handler: @escaping (Result<[Bolton]>) -> Void)
}
