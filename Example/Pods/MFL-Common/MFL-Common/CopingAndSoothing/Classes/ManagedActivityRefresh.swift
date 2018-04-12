//
//  ManagedActivityRefresh.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 23/10/2017.
//

import CoreData

final class ManagedActivityRefresh: ManagedObject {
    
    @nonobjc public class func request() -> NSFetchRequest<ManagedActivityRefresh> {
        return NSFetchRequest<ManagedActivityRefresh>(entityName: "ActivityRefresh");
    }
    
    @NSManaged var lastUpdatedDate_ : Date?
    @NSManaged var hasUserOpenedFeature_ : Bool
}


