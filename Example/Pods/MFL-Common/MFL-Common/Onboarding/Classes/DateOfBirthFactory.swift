//
//  DateOfBirthFactory.swift
//  Pods
//
//  Created by Alex Miculescu on 07/12/2017.
//
//

import Foundation

protocol HasDateOfBirthWireframe {
    var wireframe: DateOfBirthWireframe! { get }
}


public class DateOfBirthFactory {
    
    public class func wireframe() -> DateOfBirthWireframe {
        return DateOfBirthWireframeImplementation()
    }
    
    class func presenter(_ dependencies: DateOfBirthDependencies, copy: DateOfBirthCopy) -> DateOfBirthPresenter {
        return DateOfBirthPresenterImplementation(dependencies, copy: copy)
    }
}

struct DateOfBirthDependencies : HasDateOfBirthWireframe {
    var wireframe: DateOfBirthWireframe!
}
