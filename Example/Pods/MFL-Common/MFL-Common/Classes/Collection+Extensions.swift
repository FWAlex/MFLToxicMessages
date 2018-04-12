//
//  Collection+Extensions.swift
//  MFLHalsa
//
//  Created by Jonathan Flintham on 07/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
