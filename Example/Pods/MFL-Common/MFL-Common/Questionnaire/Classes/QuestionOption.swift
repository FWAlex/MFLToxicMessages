//
//  QuestionOption.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol QuestionOption : JSONEncodable {
    
    var id : Int { get }
    var value : String { get }
    var text : String { get }
    var response : String? { get }
}

//MARK: - JSONEncodable
extension QuestionOption {
    
    func json() -> [String : Any] {
        return [
            "value" : value,
            "text" : text
        ]
    }
}

