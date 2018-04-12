//
//  ManagedObjectContext+Convenience.swift
//  NGUP1
//
//  Created by Sam Wyndham on 05/06/2016.
//  Copyright © 2016 Future Workshops. All rights reserved.
//

import CoreData

public extension NSManagedObjectContext {
    
    func insertObject<T>() -> T where T: ManagedObjectType {
        return NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as! T
    }
    
    func fetch<T>(sortDescriptors: [NSSortDescriptor]? = nil) -> [T] where T: ManagedObject {
        
        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
        
        if let sortDescriptors = sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        var result = [T]()
        
        do {
            
            result = try self.fetch(fetchRequest)
        
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        
        return result
    }
}

