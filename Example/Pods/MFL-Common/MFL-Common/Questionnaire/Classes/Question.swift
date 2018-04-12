//
//  Question.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public enum QuestionType: String {
   
    case checkbox
    case radio
    case text
    case button
}

public protocol Question : JSONEncodable {
    
    var id : Int { get }
    var text : String { get }
    var answer : String? { get set }
    var type : QuestionType { get }
    var options : [QuestionOption] { get }
}

extension Question {
    
    var answerText : String? {
        
        if let answer = answer {
            
            for option in options {
                if option.value == answer { return option.text }
            }
            
            return nil
        }
        else { return nil }
    }
    
}

//MARK: - JSONEncodable
extension Question {
    
    func json() -> [String : Any] {
        
        var json = [String : Any]()
        
        json["type"] = type.rawValue
        json["text"] = text
        
        var optionsJson = [Any]()
        options.forEach { optionsJson.append($0.json()) }
        json["options"] = optionsJson
        json["answer"] = answer ?? NSNull()
        
        return json
    }
    
}
