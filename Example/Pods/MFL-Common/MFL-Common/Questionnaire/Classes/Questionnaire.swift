//
//  Questionnaire.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public enum QuestionnaireType {
    case questionnaire
    case assessment
}

public protocol Questionnaire : JSONEncodable {

    var id : String? { get }
    var slug : String? { get }
    var responseId : String { get }
    var summary : String? { get }
    var introduction : String? { get }
    var conclusion : String? { get }
    var desc : String? { get }
    var progress : Int { get set }
    var isDeclined : Bool { get set }
    var questions : [Question] { get }
    var isCompleted : Bool { get }
    var type : QuestionnaireType { get }
}

extension Questionnaire {
    
    func json() -> [String : Any] {
        
        var json = [String : Any]()
        
        json["id"] = responseId
        
        var questionsJson = [Any]()
        questions.forEach { questionsJson.append($0.json()) }
        json["questions"] = questionsJson
        
        json["status"] = isCompleted ? "complete" : "partial"
        
        if let slug = slug { json["slug"] = slug }
        if let id = id { json["id"] = id }
        if let introduction = introduction { json["introduction"] = introduction }
        if let conclusion = conclusion { json["conclusion"] = conclusion }
        
        return json
    }
}
