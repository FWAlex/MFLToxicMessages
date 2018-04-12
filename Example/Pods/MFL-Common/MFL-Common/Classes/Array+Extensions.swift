//
//  Array+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 03/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import UIKit

public extension Array {
    
    subscript<T: Sequence>(indexes: T) -> [Element] where T.Iterator.Element == Int {
        var newArr = [Element]()
        for index in indexes {
            newArr.append(self[index])
        }
        
        return newArr
    }
    
    subscript(indexes: Int...) -> [Element] {
        return self[indexes]
    }
    
    func find(_ closure: (Element) -> Bool) -> Element? {
        
        for item in self {
            if closure(item) { return item }
        }
        
        return nil
    }
    
    mutating func remove(where closure: ((Element) -> Bool)) {
        
        var indexArr = [Int]()
        
        for (index, item) in enumerated() {
            if closure(item) {
                indexArr.append(index)
            }
        }
        
        for index in indexArr.reversed() {
            self.remove(at: index)
        }
    }
    
    func removing(where closure: (Element) -> Bool) -> Array {
        var arrayToReturn = self
        arrayToReturn.remove(where: closure)
        return arrayToReturn
    }

    mutating func remove<T: Sequence>(at indexes: T) where T.Iterator.Element == Int {
        let sortedIndexes = Array<Int>(indexes).sorted(by: >)
        for index in sortedIndexes {
            remove(at: index)
        }
    }
    
    public init(count: Int, element: @autoclosure () -> Element) {
        self = (0 ..< count).map { _ in element() }
    }
}

extension Array where Element : NSLayoutConstraint {
    
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
}

func +=<T>(left: inout Array<T>, right: T) {
    left.append(right)
}

