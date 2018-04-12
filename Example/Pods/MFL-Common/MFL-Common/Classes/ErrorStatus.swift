//
//  ErrorStatus.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

enum MFLErrorType : String {
    
    case invalidRegistrationEmail = "That username is already registered or is not valid"
    case unknown = "unknown"
}

extension MFLErrorType {
    
    static func new(fromOptionaRawValue value : String?) -> MFLErrorType {
        
        guard let value = value, let type = MFLErrorType(rawValue: value) else {return .unknown}
        
        return type
    }
    
}


enum MFLErrorStatus : String {

    case badRequest = "BAD_REQUEST"
    case notFound = "NOT_FOUND"
    case methodNotAllowed = "METHOD_NOT_ALLOWED"
    case unsupportedMediaType = "UNSUPPORTED_MEDIA_TYPE"
    case internalServerError = "INTERNAL_SERVER_ERROR"
    case unauthorized = "UNAUTHORIZED"
    case invalidToken = "invalid_token"
    case noContent = "no_content"
    case unknown = "unknown"
}

extension MFLErrorStatus {
    
    static func new(fromOptionaRawValue value : String?) -> MFLErrorStatus {
        
        guard let value = value, let status = MFLErrorStatus(rawValue: value) else {return .unknown}
        
        return status
        
    }
    
}
