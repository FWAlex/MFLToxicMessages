//
//  DateOfBirthPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 07/12/2017.
//
//

import Foundation

class DateOfBirthPresenterImplementation: DateOfBirthPresenter {
    
    weak var delegate : DateOfBirthPresenterDelegate?
    fileprivate let wireframe: DateOfBirthWireframe
    fileprivate let copy : DateOfBirthCopy
    private var date : Date? { didSet { updateContinueState() } }
    private var gender : Gender? { didSet { updateContinueState() } }
    
    typealias Dependencies = HasDateOfBirthWireframe
    init(_ dependencies: Dependencies, copy: DateOfBirthCopy) {
        wireframe = dependencies.wireframe
        self.copy = copy
    }
    
    var title : String {
        return copy.title
    }
    
    var disclaimerTitle : String? {
        return copy.disclaimerTitle
    }
    
    var disclaimer : String? {
        return copy.disclaimer
    }
    
    func userSelected(_ date: Date) {
        self.date = date
    }
    
    func userSelectedGender(at index: Int) {
        self.gender = Gender.allValues[index]
    }
    
    private func updateContinueState() {
        delegate?.dateOfBirthPresenter(self, wantsToAllowContiune: (date != nil) && (gender != nil))
    }
    
    var genderCount : Int {
        return Gender.allValues.count
    }
    
    func titleForGender(at index: Int) -> String {
        return Gender.allValues[index].title
    }
    
    func userWantsToContinue() {
        let now = Date()
        guard let dob = date, now > dob, let gender = gender else { return }
        
        var registerData = RegisterData()
        registerData.dob = dob
        registerData.gender = gender
        
        wireframe.continue(with: registerData)
    }
}

fileprivate extension Gender {
    var title : String {
        switch self {
        case .male: return NSLocalizedString("Male", comment: "")
        case .female: return NSLocalizedString("Female", comment: "")
        case .agender: return NSLocalizedString("Agender", comment: "")
        case .genderFluid: return NSLocalizedString("Gender Fluid", comment: "")
        }
    }
}

