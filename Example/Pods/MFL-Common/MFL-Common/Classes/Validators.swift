//
//  Validators.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 21/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public struct Validator {
    
    public static func isValid(email: String) -> Bool {
        return validate(email, regEx: .email)
    }
    
    static func isValid(password: String) -> Bool {
        return validate(password, regEx: .password)
    }
    
    static func isValid(postcode: String) -> Bool {
        return validate(postcode, regEx: .postcode)
    }
    
    static func isValid(chatMessage: String) -> Bool {
        return validate(chatMessage, regEx: .chatMessage)
    }
    
    /** Validates only UK phone numbers */
    static func isValid(phoneNumber: String) -> Bool {
        return validate(phoneNumber, regEx: .ukPhone)
    }
    
    private static func validate(_ item: String, regEx: RegEx) -> Bool {
        return validate(item, stringRegEx: regEx.rawValue)
    }
    
    
    private static func validate(_ item: String, stringRegEx: String) -> Bool {
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", stringRegEx)
        return predicate.evaluate(with: item)
    }
}

fileprivate enum RegEx: String {
    case ukPhone = "^(((\\+44\\d{4}|\\(?0\\d{4}\\)?)\\d{3}\\d{3})|((\\+44\\d{3}|\\(?0\\d{3}\\)?)\\d{3}\\d{4})|((\\+44\\d{2}|\\(?0\\d{2}\\)?)\\d{4}\\d{4}))(\\#(\\d{4}|\\d{3}))?$"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    case password = "[^\\n\\t]{8,}"
    case postcode = "^[a-zA-Z]{1,2}([0-9]{1,2}|[0-9][a-zA-Z])\\s*[0-9][a-zA-Z]{2}$"
    case chatMessage = "[\\n\\t\\s]*([^\\n\\t\\s])+(.*)"
}

enum ValidatorError : Error {
    case invalidPhoneNumber
}


