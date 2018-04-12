//
//  NSManagedObject+Extension.swift
//  MFL-Common
//
//  Created by Yevgeniy Prokoshev on 10/04/2018.
//

import Foundation
import CoreData

//MARK: NSManagedObject Extension
public extension NSManagedObject {
    
    public static func findOrCreate<T: NSManagedObject>(with keyedValues: [String: Any], context: NSManagedObjectContext) -> T {
        let object: T? = self.findFirst(with: keyedValues, context: context)
        if let found = object {
            return found
        } else {
            var new: T!
            context.performAndWait {
                new = T.init(context: context)
                new.setValuesForKeys(keyedValues)
            }
            return new
        }
    }
    
    public static func createEntity<T: NSManagedObject>(context: NSManagedObjectContext) -> T {
        var new: T!
        context.performAndWait {
            new = T.init(context: context)
        }
        return new
    }
    
    public static func findFirst<T: NSManagedObject>(context: NSManagedObjectContext) -> T? {
        let result = T.findFirst(with: nil, context: context)
        return result as? T
    }
    
    
    public static func findFirst<T: NSManagedObject>(with keyedValues: [String: Any]?, context: NSManagedObjectContext) -> T? {
        var result: NSFetchRequestResult?
        context.performAndWait {
            let fetchRequest = self.fetchRequest()
            fetchRequest.predicate = keyedValues?.predicate
            let results = try? fetchRequest.execute()
            if let results = results, results.count > 0 {
                result = results.first
            }
        }
        
        return result as? T
    }
    
    
    public static func findAll<T: NSManagedObject>(with keyedValues: [String: Any]?, context: NSManagedObjectContext) -> [T]? {
        var results: [NSFetchRequestResult]?
        context.performAndWait {
            let fetchRequest = self.fetchRequest()
            fetchRequest.predicate = keyedValues?.predicate
            if let result = try? fetchRequest.execute() {
                results = result
            }
        }
        
        return results as? [T]
    }
}

fileprivate extension Sequence where Iterator.Element == (key: String, value: Any) {
    var predicate: NSPredicate {
        var predicateFormat: String = ""
        var values: [Any] = []
        for (key, value) in self {
            predicateFormat += "\(key) == %@ AND "
            values.append(value)
        }
        let index = predicateFormat.index(predicateFormat.endIndex, offsetBy: -5)
        predicateFormat = String(predicateFormat[..<index])
        let predicate = NSPredicate(format: predicateFormat, argumentArray: values)
        return predicate
    }
}
