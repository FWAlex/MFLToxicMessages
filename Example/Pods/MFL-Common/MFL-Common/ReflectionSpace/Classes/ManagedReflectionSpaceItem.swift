//
//  ManagedReflectionSpaceItem.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 04/10/2017.
//

import Foundation
import CoreData
import UIKit

final class ManagedReflectionSpaceItem: ManagedObject {
    
    @nonobjc public class func request() -> NSFetchRequest<ManagedReflectionSpaceItem> {
        return NSFetchRequest<ManagedReflectionSpaceItem>(entityName: "ReflectionSpaceItem");
    }
    
    @NSManaged var date_: Date
    @NSManaged var name_ : String
    @NSManaged var thumb_ : String
    @NSManaged var type_ : String
    
    class func save(name: String, thumb: String, as type: ManagedReflectionSpaceItemType, in moc: NSManagedObjectContext) -> ManagedReflectionSpaceItem {
        let item: ManagedReflectionSpaceItem = moc.insertObject()
        item.date_ = Date()
        item.name_ = name
        item.thumb_ = thumb
        item.type_ = type.rawValue
        
        return item
    }
}

extension ManagedReflectionSpaceItem : ReflectionSpaceItem {
    var date : Date {
        return date_
    }
    
    var type : ReflectionSpaceItemType {
        if type_ == ManagedReflectionSpaceItemType.image.rawValue { return .image(name: name_, thumbName: thumb_) }
        else {  return .video(name: name_, thumbName: thumb_) }
    }
}

enum ManagedReflectionSpaceItemType : String {
    case video
    case image
}

