//
//  CBMFinalScreenPresenter.swift
//  Pods
//
//  Created by Yevgeniy Prokoshev on 19/03/2018.
//
//

import Foundation

class CBMFinalScreenPresenterImplementation: CBMFinalScreenPresenter {
    
    weak var delegate : CBMFinalScreenPresenterDelegate?
   
    func showUploadInProgress() {
        delegate?.finlaScreenPresenter(self, wantsToPresentActivity: true)
    }
    
    func showError(error: Error) {
        
        let errorToPresent = MFLError(title: NSLocalizedString("Error", comment: ""),
                                      message: NSLocalizedString("There seems to be an error on our servers. Please try again later.", comment: ""))
    
        delegate?.finalScreenPresenter(self, wantsToPresent: errorToPresent)
    }
    
}
