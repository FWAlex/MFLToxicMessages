//
//  ManagedFinkelhorMetadata.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 05/12/2017.
//

import CoreData

final class ManagedFinkelhorMetadata: ManagedObject {
    
    @nonobjc public class func request() -> NSFetchRequest<ManagedFinkelhorMetadata> {
        return NSFetchRequest<ManagedFinkelhorMetadata>(entityName: "FinkelhorMetadata");
    }
    
    @NSManaged var didLoadHardcodedData : Bool
}
