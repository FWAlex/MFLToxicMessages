//
//  TableView+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 08/05/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

extension UITableView: DequeuableCellContainer {
    func dequeueReusableCell<C>(_ cell: C.Type, indexPath: IndexPath) -> C where C: Reusable {
        return self.dequeueReusableCell(withIdentifier: cell.reuseID, for: indexPath) as! C
    }
    
    func register<C>(_ nib: UINib, forCellType cellType: C.Type) where C: Reusable {
        self.register(nib, forCellReuseIdentifier: cellType.reuseID)
    }
}

extension UICollectionView: DequeuableCellContainer {
    func dequeueReusableCell<C>(_ cell: C.Type, indexPath: IndexPath) -> C where C: Reusable {
        return self.dequeueReusableCell(withReuseIdentifier: cell.reuseID, for: indexPath) as! C
    }
    
    func register<C>(_ nib: UINib, forCellType cellType: C.Type) where C: Reusable {
        self.register(nib, forCellWithReuseIdentifier: cellType.reuseID)
    }
}
