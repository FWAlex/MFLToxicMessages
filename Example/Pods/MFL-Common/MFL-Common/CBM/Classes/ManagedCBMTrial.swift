//
//  ManagedCBMTrial.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 07/03/2018.
//

import Foundation
import CoreData

final class ManagedCBMTrial: ManagedObject, JSONDecodableManagedObject {
    
    @nonobjc public class func request() -> NSFetchRequest<ManagedCBMTrial> {
        return NSFetchRequest<ManagedCBMTrial>(entityName: "CBMTrial");
    }
    
    @NSManaged var id_ : String
    @NSManaged var probePosition_ : String
    @NSManaged var imageOneURLString_ : String
    @NSManaged var imageTwoURLString_ : String
    
    @NSManaged var hidePorbeTimestamp_ : NSNumber?
    @NSManaged var userSelectTimestamp_ : NSNumber?
    @NSManaged var userSelectedWrongProbe_ : NSNumber?
    @NSManaged var userFailedToSelect_ : NSNumber?
    
    static func object(from json: MFLJson, moc: NSManagedObjectContext) -> ManagedCBMTrial {
        
        var cbmTrial : ManagedCBMTrial? = nil
        
        deleteOldTrial(with: json["id"].stringValue, moc: moc)
        cbmTrial = moc.insertObject()
        cbmTrial?.id_ = json["id"].stringValue
        cbmTrial?.probePosition_ = json["probePosition"].stringValue
        cbmTrial?.imageOneURLString_ = json["imageOne"]["url"].stringValue
        cbmTrial?.imageTwoURLString_ = json["imageTwo"]["url"].stringValue
        
        return cbmTrial!
    }
    
    private static func deleteOldTrial(with id: String, moc: NSManagedObjectContext) {
        let request = self.request()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedCBMTrial.id_), id)
        if let oldCBMTrial = moc.contextFetch(request).first {
            moc.delete(oldCBMTrial)
        }
    }
}

extension ManagedCBMTrial : CBMTrial {
    
    var id : String {
        var id = ""
        threadSafeQueue.sync { id = id_ }
        return id
    }
    
    var probePosition : CBMTrialProbePosition {
        var probePosition = CBMTrialProbePosition.imageOne
        threadSafeQueue.sync { probePosition = CBMTrialProbePosition(probePosition_) }
        return probePosition
    }
    
    var imageOneURLString : String {
        var imageOneURLString = ""
        threadSafeQueue.sync { imageOneURLString = imageOneURLString_ }
        return imageOneURLString
    }
    
    var imageTwoURLString : String {
        var imageTwoURLString = ""
        threadSafeQueue.sync { imageTwoURLString = imageTwoURLString_ }
        return imageTwoURLString
    }
    
    var hidePorbeTimestamp : TimeInterval? {
        get {
            var hidePorbeTimestamp : TimeInterval? = nil
            threadSafeQueue.sync { hidePorbeTimestamp = hidePorbeTimestamp_ == nil ? nil : TimeInterval(hidePorbeTimestamp_!.doubleValue) }
            return hidePorbeTimestamp
        }
        set {
            if newValue == nil { hidePorbeTimestamp_ = nil }
            else { hidePorbeTimestamp_ = NSNumber(value: Double(newValue!)) }
        }
    }
    
    var userSelectTimestamp : TimeInterval? {
        get {
            var userSelectTimestamp : TimeInterval? = nil
            threadSafeQueue.sync { userSelectTimestamp = userSelectTimestamp_ == nil ? nil : TimeInterval(userSelectTimestamp_!.doubleValue) }
            return userSelectTimestamp
        }
        set {
            if newValue == nil { userSelectTimestamp_ = nil }
            else { userSelectTimestamp_ = NSNumber(value: Double(newValue!)) }
        }
    }
    
    var userSelectedWrongProbe : Bool? {
        get {
            var userSelectedWrongProbe : Bool? = nil
            threadSafeQueue.sync { userSelectedWrongProbe = userSelectedWrongProbe_ == nil ? nil : userSelectedWrongProbe_!.boolValue }
            return userSelectedWrongProbe
        }
        set {
            if newValue == nil { userSelectedWrongProbe_ = nil }
            else { userSelectedWrongProbe_ = NSNumber(value: newValue!) }
        }
    }
    
    var userFailedToSelect : Bool? {
        get {
            var userFailedToSelect : Bool? = nil
            threadSafeQueue.sync { userFailedToSelect = userFailedToSelect_ == nil ? nil : userFailedToSelect_!.boolValue }
            return userFailedToSelect
        }
        set {
            if newValue == nil { userFailedToSelect_ = nil }
            else { userFailedToSelect_ = NSNumber(value: newValue!) }
        }
    }
}

private extension CBMTrialProbePosition {
    init(_ position: String) {
        switch position {
        case "imageOne": self = .imageOne
        case "imageTwo": self = .imageTwo
        default: self = .imageOne
        }
    }
}
