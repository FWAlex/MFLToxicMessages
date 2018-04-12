//
//  MFLError.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

fileprivate let defaultErrorMessage = NSLocalizedString("Sorry, an error occurred, please try again.", comment: "")

public struct MFLError {
    
    var status : MFLErrorStatus = MFLErrorStatus.new(fromOptionaRawValue: nil)
    var type : MFLErrorType = MFLErrorType.new(fromOptionaRawValue: nil)
    fileprivate var message : String = defaultErrorMessage
    fileprivate var customTitle : String?
}

extension MFLError {
    
    static var defaultTitle : String {
        return Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    }

    var title : String {
        return self.alertInfo.title
    }
    
    var displayMessage : String {
        return self.alertInfo.message
    }
    
    private var alertInfo : (title : String, message : String){
        
        if self.status == .invalidToken {
            return (MFLError.defaultTitle, NSLocalizedString("Your session has expired. Please login again.", comment: ""))
        }
        
        let title = customTitle != nil ? customTitle! : MFLError.defaultTitle
        
        return (title, self.message)
    }
}

extension MFLError : JSONDecodable {
    
    /*
    init(json : JSON) {
        
        self.status = ErrorStatus.new(fromOptionaRawValue: json["status"].stringValue)
        self.message = json["message"].string ?? defaultErrorMessage
        self.errorType = ErrorType.new(fromOptionaRawValue: json["errorType"].stringValue)
        
        //different error format
        if let error = json["error"].string {
            self.status = ErrorStatus.new(fromOptionaRawValue: error)
        }
        
        if let errorDescription = json["error_description"].string {
            self.message = errorDescription
        }
    }
 */
    
    public init?(json: MFLJson) {
        
        let errors = json["errors"].arrayValue
        guard errors.count > 0 else { return nil }
        
        self.message = errors[0]["message"].stringValue
    }
    
    init(status : MFLErrorStatus) {
        self.status = status
    }
    
    init(string: String) {
        
        self.type = MFLErrorType.new(fromOptionaRawValue: string)
        self.message = string
    }
    
    public init(title: String, message: String) {
        customTitle = title
        self.message = message
    }
    
    init?(code: Int) {
        
        switch code {
        case 401:
            self.message = NSLocalizedString("Your session has expired", comment: "")
            self.status = .unauthorized
        case 404:
            self.message = NSLocalizedString("Not Found", comment: "")
            self.status = .notFound
        default:
            return nil
        }
        
    }
    
}

extension MFLError : Error {

    var localizedDescription: String {
        return self.displayMessage
    }
    
}

extension MFLError: LocalizedError {
    public var errorDescription: String? {
        return self.displayMessage
    }
}
