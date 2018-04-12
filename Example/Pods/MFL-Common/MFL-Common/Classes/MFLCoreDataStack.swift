//
//  MFLCoreDataStack.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 28/09/2017.
//

import CoreData

public class MFLCoreDataStack {

    private var storeContainer : NSPersistentContainer!
    private var containerName : String
    private var containerBundle : Bundle?
    
    func setUpContainer() {
        
        if let bundle = containerBundle {
            storeContainer = NSPersistentContainer(name: containerName, in: bundle)
        } else {
            storeContainer = NSPersistentContainer(name: containerName)
        }
        
        storeContainer?.loadPersistentStores { (storeDescription, error) in
            
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    public var moc : NSManagedObjectContext {
        return self.storeContainer.viewContext
    }
    
    public init(modelName: String, in bundle: Bundle?) {
        containerName = modelName
        if let bundle = bundle {
            containerBundle = bundle
        } else {
            containerBundle = MFLCommon.shared.appBundle
        }
        setUpContainer()
    }
    
    func saveContext() {
        
        guard moc.hasChanges else { return }
        
        do {
            try moc.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    public func dropAllData() {
        self.storeContainer.managedObjectModel.entities.flatMap {
            guard let name = $0.name else {
                print("This entity doesn't have a name: \($0)")
                return nil
            }
            let fetch:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: name)
            return fetch
            }.forEach {
                self.delete(fetch: $0)
        }
        
        self.moc.performAndWait {
            do {
                try self.moc.save()
            } catch {
                print("Error trying to save the context: \(error)")
            }
        }
    }
    
    private func delete(fetch: NSFetchRequest<NSFetchRequestResult>) {
        do {
            try self.moc.fetch(fetch).forEach {
                guard let managedObject = $0 as? NSManagedObject else {
                    print("The object was not a NSmanagedObject: \($0)")
                    return
                }
                self.moc.delete(managedObject)
            }
        } catch {
            print("Error on deleting entity: \(fetch.entity?.name ?? ""): \(error.localizedDescription)")
        }
    }
}

fileprivate extension NSPersistentContainer {
    
    public convenience init(name: String, in bundle: Bundle) {
    
        guard let modelURL = bundle.url(forResource: name, withExtension: "momd"),
            let mom = NSManagedObjectModel(contentsOf: modelURL)
            else {
                fatalError("Unable to located Core Data model")
        }

        self.init(name: name, managedObjectModel: mom)
    }
    
}

