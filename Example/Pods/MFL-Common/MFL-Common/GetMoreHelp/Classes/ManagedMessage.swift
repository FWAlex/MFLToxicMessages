//
//  ManagedMessage.swift
//  
//
//  Created by Alex Miculescu on 27/01/2017.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

final class ManagedMessage: ManagedObject, JSONDecodableManagedObject {

    @nonobjc public class func request() -> NSFetchRequest<ManagedMessage> {
        return NSFetchRequest<ManagedMessage>(entityName: "Message");
    }
    
    fileprivate static let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        
        return dateFormatter
    }()
    
    @NSManaged var id_ : String
    @NSManaged var senderId_ : String
    @NSManaged var senderName_ : String
    @NSManaged var text_ : String
    @NSManaged var sentAt_ : Date?
    @NSManaged var imageUrlString_: String?
    @NSManaged var isSent_: NSNumber?
 
    static func object(from json: MFLJson, moc: NSManagedObjectContext) -> ManagedMessage {
        
        let fetchRequest = ManagedMessage.request()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedMessage.id_), json["id"].stringValue)
        let messages = moc.contextFetch(fetchRequest)
        
        var managedMessage: ManagedMessage
        
        if let message = messages.first {
            managedMessage = message
        } else {
            managedMessage = moc.insertObject()
        }
        
        managedMessage.id_ = json["id"].stringValue
        managedMessage.senderId_ = json["author"]["id"].stringValue
        managedMessage.senderName_ = json["author"]["firstname"].stringValue
        managedMessage.imageUrlString_ = json["author"]["photo"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? json["author"]["photo"].stringValue
        managedMessage.text_ = json["message"].stringValue
        managedMessage.sentAt_ =  dateFormatter.date(from: json["sentAt"].stringValue)
        
        return managedMessage
    }

}

extension ManagedMessage: Message {
    
    var id : String {
        return id_
    }
    
    var senderId : String {
        return senderId_
    }
    
    var senderName : String {
        return senderName_
    }

    var text : String {
        return text_
    }
    
    var sentAt : Date? {
        return sentAt_
    }
    
    var imageUrlString : String? {
        return imageUrlString_
    }
    
    var isSent : Bool? {
        return isSent_?.boolValue
    }
}
