//
//  EmergencyContactPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 28/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import UIKit

fileprivate let phoneNumberEmptyErrorMessage    = NSLocalizedString("Please enter a phone number", comment: "")
fileprivate let phoneNumberInvalidErrorMessage  = NSLocalizedString("Please enter a valid phone number", comment: "")
fileprivate let firstNameEmptyErrorMessage      = NSLocalizedString("Please enter your contact first name", comment: "")
fileprivate let lastNameEmptyErrorMessage       = NSLocalizedString("Please enter your contact last name", comment: "")
fileprivate let relationshipEmptyErrorMessage   = NSLocalizedString("Please enter the relationship you have", comment: "")

fileprivate let termsAndConditionsLinkId = "termsAndConditionsLinkId"

class EmergencyContactPresenterImplementation: EmergencyContactPresenter {
    
    weak var delegate : EmergencyContactPresenterDelegate?
    fileprivate let interactor : EmergencyContactInteractor
    fileprivate let wireframe : EmergencyContactWireframe
    fileprivate let payable : Payable
    fileprivate lazy var user : User = {
        return self.interactor.currentUser()
    }()
    
    typealias Dependencies = HasEmergencyContactInteractor & HasEmergencyContactWireframe & HasPayable
    
    init(_ dependencies: Dependencies) {
        interactor = dependencies.emergencyContactInteractor
        wireframe = dependencies.emergencyContactWireframe
        payable = dependencies.payable
    }
    
    fileprivate lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter
    }()
    
    fileprivate lazy var numberFormatter : NumberFormatter = {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.currencySymbol = "£"
        numberFormatter.numberStyle = .currency
        
        return numberFormatter
    }()
    
    //MARK: - Exposed
    
    var infoTitle :String {
        return NSLocalizedString("WHY WE NEED THIS INFORMATION", comment: "")
    }
    
    var infoText : String {
        return NSLocalizedString("It’s a security measure we need to take. If we believe you’re in crisis we will contact someone of your choice, on your behalf.", comment: "")
    }
    
    var ice : EmergencyContactData? {
        guard let ice = user.ice else { return nil }
        return EmergencyContactData(ice)
    }
    
    var isDeviceSupportingApplePay : Bool {
        return interactor.isDeviceSupportingApplePay
    }
    
    var hasUserCardSaved: Bool {
        return interactor.hasUserCardSaved
    }
    
    func submitEmergencyContactAndContinue(phoneNumber: String?,
                                           firstName: String?,
                                           lastName: String?,
                                           relationship: String?) throws {
        
        MFLAnalytics.record(event: .buttonTap(name: "Emergency Contact Screen Pay With Card Tapped", value: nil))
        
        try submitEmergencyContact(phoneNumber: phoneNumber,
                                   firstName: firstName,
                                   lastName: lastName,
                                   relationship: relationship)
        { [unowned self] error in
            
            self.delegate?.emergencyContactPresenter(self, didFinishUpdateWith: error)
                                    
            guard error == nil else { return }
            
            
            if self.hasUserCardSaved {
                guard let bolton = self.payable as? Bolton else {
                    assertionFailure("Paying with saved card for anything other than Boltons is not yet supported")
                    return
                }
                
                self.delegate?.emergencyContactPresenterDidStartUpdate(self)
                
                self.interactor.payFor(bolton) {
                    switch $0 {
                    case .success(_):
                        self.delegate?.emergencyContactPresenter(self, didFinishUpdateWith: nil)
                        self.delegate?.emergencyContactPresenter(self, wantsToPresent: self.successAlert())
                    case .failure(let error): self.delegate?.emergencyContactPresenter(self, wantsToPresent: error)
                    }
                }
                
            } else {
                self.wireframe.showPayWithCardPage(for: self.payable)
            }
        }
    }
    
    func submitEmergencyContactAndApplePay(phoneNumber: String?,
                                           firstName: String?,
                                           lastName: String?,
                                           relationship: String?,
                                           viewController: UIViewController) throws {
        
        MFLAnalytics.record(event: .buttonTap(name: "Emergency Contact Screen Pay With ApplePay Tapped", value: nil))
    
        try submitEmergencyContact(phoneNumber: phoneNumber,
                                   firstName: firstName,
                                   lastName: lastName,
                                   relationship: relationship)
        { [unowned self] error in
            
            self.delegate?.emergencyContactPresenter(self, didFinishUpdateWith: error)
            
            if error != nil { return }
            
            self.interactor.applePay(for: self.payable, on: viewController) { [unowned self] error in
                
                guard error == nil else { return }
                
                self.delegate?.emergencyContactPresenter(self, wantsToPresent: self.successAlert())
            }
        }
    }
    
        
    
    fileprivate func submitEmergencyContact(phoneNumber: String?,
                                firstName: String?,
                                lastName: String?,
                                relationship: String?,
                                handler: @escaping (Error?) -> Void) throws {
        
        let data = try extractDataFrom(phoneNumber: phoneNumber,
                                       firstName: firstName,
                                       lastName: lastName,
                                       relationship: relationship)
        
        if ice != data {
            update(ice: data, handler: handler)
        } else {
            handler(nil)
        }
        
    }
    
    func validate(phoneNumber: String?) -> String? {
        if mfl_nilOrEmpty(phoneNumber) { return phoneNumberEmptyErrorMessage }
        if !Validator.isValid(phoneNumber: phoneNumber!) { return phoneNumberInvalidErrorMessage }
        return nil
    }
    
    func validate(firstName: String?) -> String? {
        if mfl_nilOrEmpty(firstName) { return firstNameEmptyErrorMessage }
        return nil
    }
    
    func validate(lastName: String?) -> String? {
        if mfl_nilOrEmpty(lastName) { return lastNameEmptyErrorMessage }
        return nil
    }
    
    func validate(relationship: String?) -> String? {
        if mfl_nilOrEmpty(relationship) { return relationshipEmptyErrorMessage }
        return nil
    }
}

//MARK: - Helper
extension EmergencyContactPresenterImplementation {
   
    fileprivate func extractDataFrom(phoneNumber: String?,
                                     firstName: String?,
                                     lastName: String?,
                                     relationship: String?) throws -> EmergencyContactData {
        
        var errors = [EmergencyContactErrorType]()
    
        if let errorMessage = validate(phoneNumber: phoneNumber) { errors.append(.phoneNumber(errorMessage)) }
        if let errorMessage = validate(firstName: firstName) { errors.append(.firstName(errorMessage)) }
        if let errorMessage = validate(lastName: lastName) { errors.append(.lastName(errorMessage)) }
        if let errorMessage = validate(relationship: firstName) { errors.append(.relationship(errorMessage)) }
        
        if errors.count != 0 { throw EmergencyContactError(errors: errors) }
        
        return EmergencyContactData(firstName: firstName!,
                                    lastName: lastName!,
                                    phoneNumber: phoneNumber!,
                                    relationship: relationship!)
    }
    
    fileprivate func update(ice: EmergencyContactData, handler: @escaping (Error?) -> Void) {
        delegate?.emergencyContactPresenterDidStartUpdate(self)
        interactor.updateUser(ice: ice, handler: handler)
    }
    
    fileprivate func successAlert() -> UIAlertController {
        
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""),
                                      message: NSLocalizedString("You have just purchased \(payable.name).", comment: ""),
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .default) { _ in self.wireframe.finish() }
        
        alert.addAction(okAction)
        
        return alert
    }
}

extension EmergencyContactData : ICE {
    
    init(_ ice: ICE) {
        firstName = ice.firstName
        lastName = ice.lastName
        phoneNumber = ice.phoneNumber
        relationship = ice.relationship
    }
}

fileprivate func ==(lhs: EmergencyContactData?, rhs: EmergencyContactData) -> Bool {
    
    guard let lhs = lhs else { return false }
    
    return lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.phoneNumber == rhs.phoneNumber &&
        lhs.relationship == rhs.relationship
}

fileprivate func !=(lhs: EmergencyContactData?, rhs: EmergencyContactData) -> Bool {
    return !(lhs == rhs)
}
