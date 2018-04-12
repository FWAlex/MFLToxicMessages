//
//  PayWithCardPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 01/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

fileprivate let noCardParamsErrorMessage = NSLocalizedString("Please fill in your card details", comment: "")
fileprivate let noAddressErrorMessage = NSLocalizedString("Please fill in your billing address", comment: "")
fileprivate let noPostCodeErrorMessage = NSLocalizedString("Please fill in your billing post code", comment: "")
fileprivate let invalidPostCodeErrorMessage = NSLocalizedString("Please fill in a valid UK post code", comment: "")

class PayWithCardPresenterImplementation: PayWithCardPresenter {
    
    weak var delegate : PayWithCardPresenterDelegate?
    
    fileprivate let interactor: PayWithCardInteractor
    fileprivate let wireframe: PayWithCardWireframe
    fileprivate let payable : Payable?
    fileprivate let alertText : AlertText?
    
    typealias Dependencies = HasPayWithCardWireframe & HasPayWithCardInteractor
    
    init(_ dependencies: Dependencies, payable: Payable?, alertText: AlertText?) {
        interactor = dependencies.payWithCardInteractor
        wireframe = dependencies.payWithCardWireframe
        self.alertText = alertText
        self.payable = payable
    }
    
    var submitText : String {
        return payable == nil ? NSLocalizedString("Submit Card Details", comment: "") : NSLocalizedString("Finish Payment", comment: "")
    }
    
    func isValid(cardDetails: CardDetails) -> String? {
        
        if mfl_nilOrEmpty(cardDetails.number) ||
            mfl_nilOrEmpty(cardDetails.cvc) ||
            cardDetails.expirationMonth == 0 ||
            cardDetails.expirationYear == 0 {
            return noCardParamsErrorMessage
        }
        
        return nil
    }
    
    func isValid(address: String?) -> String? {
        
        if mfl_nilOrEmpty(address) {
            return noAddressErrorMessage
        }
        
        return nil
    }
    
    func isValid(postCode: String?) -> String? {
        
        if mfl_nilOrEmpty(postCode) {
            return noPostCodeErrorMessage
        } else if !Validator.isValid(postcode: postCode!) {
            return invalidPostCodeErrorMessage
        }
        
        return nil
    }
    
    func userWantsToFinishPaymentWith(_ cardDetails: CardDetails) throws {
        
        let cardDetils = try validate(cardDetails: cardDetails)
        
        delegate?.payWithCardPresenterDidStartPaying(self)
        
        if let payable = payable {
            pay(for: payable, with: cardDetils)
        } else {
            addCard(with: cardDetails)
        }
    }
}

//MARK: - Helper
fileprivate extension PayWithCardPresenterImplementation {
    
    func validate(cardDetails: CardDetails) throws -> CardDetails {
        
        var errors = [PayWithCardErrorType]()
        
        if let error = isValid(cardDetails: cardDetails) {
            errors.append(.cardParams(error))
        }
        
        if let error = isValid(address: cardDetails.address) {
            errors.append(.address(error))
        }
        
        if let error = isValid(postCode: cardDetails.postCode) {
            errors.append(.postCode(error))
        }
        
        if errors.count > 0 { throw PayWithCardError(errors: errors) }
        
        return cardDetails
    }
    
    func pay(for payable: Payable, with cardDetails: CardDetails) {
        interactor.pay(for: payable, using: cardDetails, handler: handleResult(_:))
    }
    
    func addCard(with cardDetails: CardDetails) {
        interactor.addCard(with: cardDetails, handler: handleResult(_:))
    }
    
    func handleResult(_ result: Result<User?>) {
        switch result {
        case .success(_):
            self.delegate?.payWithCardPresenter(self, didFinishPayingWith: nil)
            self.continue()
            
        case .failure(let error): self.delegate?.payWithCardPresenter(self, didFinishPayingWith: error)
        }
    }
    
    
    func `continue`() {
        
        guard let alertText = alertText else {
            self.wireframe.finish()
            return
        }
        
        let alert = UIAlertController.alert(with: alertText)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .default) { _ in self.wireframe.finish() }
        
        alert.addAction(okAction)
        
        delegate?.payWithCardPresenter(self, wantsToShow: alert)
    }
}




