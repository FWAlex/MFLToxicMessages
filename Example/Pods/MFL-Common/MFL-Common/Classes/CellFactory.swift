//
//  StagesFlow.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 22/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//


import UIKit

protocol DequeuableCellContainer {
    func dequeueReusableCell<C>(_ cell: C.Type, indexPath: IndexPath) -> C where C: Reusable

    func register<C>(_ nib: UINib, forCellType cellType: C.Type) where C: Reusable
}

struct CellFactory {
    fileprivate(set) var registeredIDs: Set<String> = []

    let container: DequeuableCellContainer
    
    init(container: DequeuableCellContainer) {
        self.container = container
    }

    mutating func dequeueReusableCell<T>(_ cellType: T.Type, at indexPath: IndexPath, in bundle: Bundle) -> T where T: Reusable, T: NibInstantiable {
        let reuseID = cellType.reuseID
        if registeredIDs.contains(reuseID) == false {
            container.register(cellType.nib(in: bundle), forCellType: cellType)
            registeredIDs.insert(reuseID)
        }
        return container.dequeueReusableCell(cellType, indexPath: indexPath)
    }
}
