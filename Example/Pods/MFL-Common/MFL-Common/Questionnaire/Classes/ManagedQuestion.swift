//
//  ManagedQuestion.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import CoreData

final class ManagedQuestion: ManagedObject, JSONDecodableManagedObject {
    
    @nonobjc public class func request() -> NSFetchRequest<ManagedQuestion> {
        return NSFetchRequest<ManagedQuestion>(entityName: "Question");
    }
    
    @NSManaged var id_: NSNumber
    @NSManaged var text_: String
    @NSManaged var answer_: String?
    @NSManaged var type_: String
    @NSManaged var options_: NSOrderedSet
    
    static func object(from json: MFLJson, moc: NSManagedObjectContext) -> ManagedQuestion {
        
        let managedQuestion: ManagedQuestion = moc.insertObject()
        
        managedQuestion.id_     = NSNumber(value: json["id"].intValue)
        managedQuestion.text_   = json["text"].stringValue
        managedQuestion.answer_ = json["answer"].string
        managedQuestion.type_   = json["type"].stringValue
    
        let optionsJSON = json["options"].arrayValue
            
        let managedOptions = NSMutableOrderedSet()
        
        var optionId = 0
        for option in optionsJSON {
            let managedOption = ManagedQuestionOption.object(from: option, moc: moc)
            managedOption.id_ = NSNumber(value: optionId)
            
            managedOptions.add(managedOption)
            
            optionId += 1
        }
            
        managedQuestion.options_ = managedOptions
        
        return managedQuestion
    }
}

extension ManagedQuestion : Question {
    
    var id : Int {
        return id_.intValue
    }
    
    var text : String {
        return text_
    }
    
    var answer : String? {
        get { return answer_ }
        set { answer_ = newValue }
    }
    
    var type : QuestionType {
        return QuestionType.new(value: type_)!
    }
    
    var options : [QuestionOption] {
        return options_.array as! [QuestionOption]
    }
}

extension QuestionType {
    
    static func new(value: String) -> QuestionType? {
        
        switch value {
        case "checkbox": return .checkbox
        case "radio": return .radio
        case "text": return .text
        case "button": return .button
        default: return nil
        }
    }
}
