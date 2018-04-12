//
//  UIAlertController+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 15/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func alert(with alertText: AlertText) -> UIAlertController {
        return UIAlertController(title: alertText.title,
                                 message: alertText.message,
                                 preferredStyle: .alert)
    }
    
    static func okAlertWith(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        return alert
    }
    
    func add(_ actions: [UIAlertAction]) {
        actions.forEach { self.addAction($0) }
    }
    
    
    static func alert(for error: Error, handler: (() -> Void)? = nil) -> UIAlertController {
        
        var alert: UIAlertController!
        
        if let error = error as? MFLError {
            alert = UIAlertController(title: error.title, message: error.displayMessage, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: MFLError.defaultTitle, message: error.localizedDescription, preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction.okAction(with: handler))
        
        return alert
    }
}

extension UIAlertAction {
    static func okAction(with handler: (() -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in handler?() }
    }
}
