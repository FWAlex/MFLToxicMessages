//
//  ManagedFinkelhorBehaviour.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 05/12/2017.
//

import CoreData

final class ManagedFinkelhorBehaviour: ManagedObject, JSONDecodableManagedObject {
    
    @nonobjc public class func request() -> NSFetchRequest<ManagedFinkelhorBehaviour> {
        return NSFetchRequest<ManagedFinkelhorBehaviour>(entityName: "FinkelhorBehaviour");
    }
    
    @NSManaged var category_ : String
    @NSManaged var section_ : String
    @NSManaged var selection_ : String?
    @NSManaged var text_ : String
    
    static func object(from json: MFLJson, moc: NSManagedObjectContext) -> ManagedFinkelhorBehaviour {
        
        let managedFinkelhorBehaviour: ManagedFinkelhorBehaviour = moc.insertObject()
        
        managedFinkelhorBehaviour.category_ = json["category"].stringValue
        managedFinkelhorBehaviour .section_ = json["section"].stringValue
        managedFinkelhorBehaviour.text_ = json["text"].stringValue
        
        return managedFinkelhorBehaviour
    }
}

extension ManagedFinkelhorBehaviour : FinkelhorBehaviour {
    
    var category : FinkelhorCategory { return FinkelhorCategory(category_)! }
    var section : String { return section_ }
    var text : String { return text_ }
    var selection : FinkelhorBehaviourSelection {
        get { return FinkelhorBehaviourSelection(selection_) }
        set { selection_ = newValue.string }
    }
}

fileprivate extension FinkelhorBehaviourSelection {
    
    init(_ string: String?) {
        switch string {
        case .some("now"): self = .now
        case .some("past"): self = .past
        default: self = .none
        }
    }
    
    var string : String? {
        switch self {
        case .now: return "now"
        case .past: return "past"
        case .none: return nil
        }
    }
}

fileprivate extension FinkelhorCategory {
    
    init?(_ string: String) {
        switch string {
        case "traumaticSexualisation": self = .traumaticSexualisation
        case "powerlessness": self = .powerlessness
        case "betrayal": self = .betrayal
        case "stigmatisation": self = .stigmatisation
        default: return nil
        }
    }
}
