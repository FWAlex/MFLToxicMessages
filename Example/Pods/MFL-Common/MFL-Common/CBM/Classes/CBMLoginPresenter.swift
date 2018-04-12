//
//  CBMLoginPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 07/03/2018.
//
//

import Foundation

class CBMLoginPresenterImplementation: CBMLoginPresenter {
    
    weak var delegate : CBMLoginPresenterDelegate?
    
    //MARK: - Exposed
    
    func show(inProgress: Bool) {
        delegate?.cbmLoginPresenter(self, wantsToPresentActivity: inProgress)
    }
    
    func present(_ error: Error) {
    
        var errorToPresent = error
        if let mflError = error as? MFLError, mflError.status == .unauthorized {
            errorToPresent = MFLError(title: NSLocalizedString("Error", comment: ""),
                                      message: NSLocalizedString("It seems that the identifier you have entered is invalid.", comment: ""))
        } else {
            // We will display any error as a generic error
            errorToPresent = MFLError(title: NSLocalizedString("Error", comment: ""),
                                      message: NSLocalizedString("There seems to be an error on our servers. Please try again later.", comment: ""))
        }
        
        delegate?.cbmLoginPresenter(self, wantsToPresent: errorToPresent)
    }
}
