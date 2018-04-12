//
//  CBMSessionInfoPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 08/03/2018.
//
//

import UIKit

class CBMSessionInfoPresenterImplementation: CBMSessionInfoPresenter {
  

    weak var delegate : CBMSessionInfoPresenterDelegate?
    
    func presentError(error: Error?, callback: (() -> Void)? ) {
        
        var errorToPresent: Error!
        
        if let error = error {
            errorToPresent = error
        } else {
            errorToPresent = MFLError(title: NSLocalizedString("Error", comment: ""),
                                      message: NSLocalizedString("An error has occured while fetching the required assets.\nPlease try again.", comment: ""))
        }
        
        let alert = UIAlertController.alert(for: errorToPresent)
        let action = UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: .default) {_ in callback?() }
        
        alert.addAction(action)
        
        delegate?.sessionPresenter(self, wantsToPresent: alert)
    }
    
    func showLoadingInProgress() {
        delegate?.sessionPresenter(self, wantsToPresentActivity: true)
    }
    
    func showDownloadSuccess() {
        delegate?.sessionPresenter(self, wantsToPresentActivity: false)
    }
}
