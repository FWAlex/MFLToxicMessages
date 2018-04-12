//
//  ManagedQuestionOption.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 22/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import CoreData

final class ManagedQuestionOption: ManagedObject, JSONDecodableManagedObject {
    
    @nonobjc public class func request() -> NSFetchRequest<ManagedQuestionOption> {
        return NSFetchRequest<ManagedQuestionOption>(entityName: "QuestionOption");
    }
    
    @NSManaged var id_ : NSNumber
    @NSManaged var value_ : String
    @NSManaged var text_ : String
    @NSManaged var response_ : String?
    
    static func object(from json: MFLJson, moc: NSManagedObjectContext) -> ManagedQuestionOption {
        
        let managedQuestionOption: ManagedQuestionOption = moc.insertObject()
        
        managedQuestionOption.value_    = json["value"].stringValue
        managedQuestionOption.text_     = json["text"].stringValue
        managedQuestionOption.response_ = json["response"].string // <- we want this to be nil if the json has no "response" field
        
        return managedQuestionOption
    }
}

extension ManagedQuestionOption : QuestionOption {
    
    var id : Int {
        return id_.intValue
    }
    
    var value : String {
        return value_
    }
    
    var text : String {
        return text_
    }
    
    var response : String? {
        return response_
    }
}
