//
//  DateOfBirthInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 07/12/2017.
//
//

import UIKit

public struct DateOfBirthCopy {
    var title : String
    var disclaimerTitle : String?
    var disclaimer : String?
    
    public init(title: String, disclaimerTitle: String? = nil, disclaimer: String? = nil) {
        self.title = title
        self.disclaimerTitle = disclaimerTitle
        self.disclaimer = disclaimer
    }
}

//MARK: - Presenter
protocol DateOfBirthPresenterDelegate : class {
    func dateOfBirthPresenter(_ sender: DateOfBirthPresenter, wantsToAllowContiune isContinueAllowed: Bool)
}

protocol DateOfBirthPresenter {
    
    weak var delegate : DateOfBirthPresenterDelegate? { get set }
    
    var title : String { get }
    var disclaimerTitle : String? { get }
    var disclaimer : String? { get }
    
    func userSelected(_ date: Date)
    func userSelectedGender(at index: Int)
    
    func userWantsToContinue()
    var genderCount : Int { get }
    func titleForGender(at index: Int) -> String
}

//MARK: - Wireframe

public protocol DateOfBirthWireframeDelegate : class {
    func dateOfBirthWireframe(_ sender: DateOfBirthWireframe, wantsToContinueWith registerData: RegisterData)
}

public protocol DateOfBirthWireframe {
    
    weak var delegate : DateOfBirthWireframeDelegate? { get set }
    
    func viewController(_ dependencies: HasStyle, copy: DateOfBirthCopy) -> UIViewController
    func `continue`(with registerData: RegisterData)
}
