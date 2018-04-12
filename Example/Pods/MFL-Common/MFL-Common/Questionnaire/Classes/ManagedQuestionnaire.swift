//
//  ManagedQuestionnaire.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import CoreData

final class ManagedQuestionnaire: ManagedObject, JSONDecodableManagedObject {
    
    @nonobjc public class func request() -> NSFetchRequest<ManagedQuestionnaire> {
        return NSFetchRequest<ManagedQuestionnaire>(entityName: "Questionnaire");
    }
    
    @NSManaged var id_ : String?
    @NSManaged var responseId_ : String
    @NSManaged var summary_ : String?
    @NSManaged var desc_ : String?
    @NSManaged var progress_ : NSNumber
    @NSManaged var declined_ : Bool
    @NSManaged var questions_ : NSOrderedSet
    @NSManaged var isSignUp_ : Bool
    @NSManaged var isCompleted_ : Bool
    @NSManaged var type_ : String
    
    @NSManaged var slug_ : String?
    @NSManaged var introduction_ : String?
    @NSManaged var conclusion_ : String?
    
    static func object(from json: MFLJson, moc: NSManagedObjectContext) -> ManagedQuestionnaire {
        
        let managedQuestionnaire: ManagedQuestionnaire = moc.insertObject()
        
        managedQuestionnaire.id_        = json["id"].int != nil ? "\(json["id"].intValue)" : nil
        managedQuestionnaire.responseId_ = json["id"].stringValue
        managedQuestionnaire.summary_   = json["summary"].string
        managedQuestionnaire.desc_      = json["description"].string
        managedQuestionnaire.slug_      = json["slug"].string
        managedQuestionnaire.introduction_ = json["introduction"].string
        managedQuestionnaire.conclusion_ = json["conclusion"].string
        
        /** declined_ will be completed by the user */
        
        let questions = NSMutableOrderedSet()
        
        for (index, questionJSON) in json["questions"].arrayValue.enumerated() {
            let question = ManagedQuestion.object(from: questionJSON, moc: moc)
            questions.add(question)
            
            // The progress is the index of the last question that has a non-nil answer
            if question.answer != nil {
                managedQuestionnaire.progress_ = NSNumber(value: index + 1)
            }
        }
        
        managedQuestionnaire.questions_ = questions
        managedQuestionnaire.isCompleted_ = (managedQuestionnaire.progress_.intValue == questions.count)
        
        return managedQuestionnaire
    }
}

extension ManagedQuestionnaire : Questionnaire {
 
    var id : String? {
        return id_
    }
    
    var responseId : String {
        return responseId_
    }
 
    var summary : String? {
        return summary_
    }
    
    var desc : String? {
        return desc_
    }
    
    var progress : Int {
        get { return progress_.intValue }
        set {
            isCompleted_ = newValue == questions_.count
            progress_ = NSNumber(value: newValue)
        }
    }
    var isDeclined : Bool {
        get { return declined_ }
        set { declined_ = newValue }
    }
    
    var questions : [Question] {
        return questions_.array as! [Question]
    }
    
    var isCompleted : Bool {
        return isCompleted_
    }
    
    var type : QuestionnaireType {
        return QuestionnaireType(string: type_)!
    }
    
    var slug : String? {
        return slug_
    }
    
    var introduction : String? {
        return introduction_
    }
    
    var conclusion : String? {
        return conclusion_
    }
}

extension QuestionnaireType {
    init?(string: String) {
        switch string {
        case "assessment": self = .assessment
        case "questionnaire": self = .questionnaire
        default: return nil
        }
    }
}
