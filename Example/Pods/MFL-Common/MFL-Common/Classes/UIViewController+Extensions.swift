//
//  UIViewController+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 26/01/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func mfl_present(_ viewController: UIViewController, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = BluredModalTransitionController.default
        
        present(viewController, animated: animated, completion: completion)
    
    }
    
    static var name : String {
        return String(describing: self)
    }

    func showSimpleAlert(title: String?, message: String?, handler: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in handler?() }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    public func showAlert(for error: Error, handler: (() -> Void)? = nil) {
        let alert = UIAlertController.alert(for: error, handler: handler)
        present(alert, animated: true, completion: nil)
    }
}
