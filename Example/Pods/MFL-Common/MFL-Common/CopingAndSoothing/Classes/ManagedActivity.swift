//
//  ManagedActivity.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 23/10/2017.
//

import CoreData

final class ManagedActivity: ManagedObject, JSONDecodableManagedObject {
    
    @nonobjc public class func request() -> NSFetchRequest<ManagedActivity> {
        return NSFetchRequest<ManagedActivity>(entityName: "Activity");
    }
    
    @NSManaged var id_ : String
    @NSManaged var type_ : String
    @NSManaged var text_ : String
    @NSManaged var isSelected_ : Bool
    
    static func object(from json: MFLJson, moc: NSManagedObjectContext) -> ManagedActivity {
        
        let managedActivity: ManagedActivity = moc.insertObject()
        
        managedActivity.id_ = json["id"].stringValue
        managedActivity.text_ = json["activity"].stringValue
        let type: CSActivityType = json["doMore"].boolValue ? .doMore : .doLess
        managedActivity.type_ = type.string
        managedActivity.isSelected_ = json["isSelected"].boolValue
        
        return managedActivity
    }
}

extension ManagedActivity : CSActivity {
    
    var id : String {
        return id_
    }
    
    var text : String {
        return text_
    }
    
    var type : CSActivityType {
        return CSActivityType(type_)
    }
    
    var isSelected : Bool {
        get { return isSelected_ }
        set { isSelected_ = newValue }
    }
}

extension CSActivityType {
    var string : String {
        switch self {
        case .doMore: return "doMore"
        case .doLess: return "doLess"
        }
    }
    
    init(_ string: String) {
        if string == CSActivityType.doMore.string { self = .doMore }
        else { self = .doLess }
    }
}
