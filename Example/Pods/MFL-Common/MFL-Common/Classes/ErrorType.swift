//
//  ErrorType.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//


import Foundation

enum ErrorType : String {
    
    case validation = "VALIDATION"
    case internalServerError = "INTERNAL"
    case badRequest = "BAD_REQUEST"
    case methodNotAllowed = "METHOD_NOT_ALLOWED"
    case unsupportedMediaType = "UNSUPPORTED_MEDIA_TYPE"
    case unknown = "unknown"
}

extension ErrorType {
    
    static func new(fromOptionaRawValue value : String?) -> ErrorType {
        
        guard let value = value, let status = ErrorType(rawValue: value) else {return .unknown}
        
        return status
        
    }
    
}
