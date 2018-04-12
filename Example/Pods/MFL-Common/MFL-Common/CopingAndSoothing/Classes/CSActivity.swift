//
//  Activity.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 23/10/2017.
//

import Foundation

enum CSActivityType {
    case doMore
    case doLess
}

protocol CSActivity : JSONEncodable {
    var id : String { get }
    var text : String { get }
    var isSelected : Bool { get set }
    var type : CSActivityType { get }
}

extension CSActivity {
    func json() -> [String : Any] {
        var json = [String : Any]()
        
        json["activity"] = text
        json["isSelected"] = isSelected
        json["doMore"] = type == .doMore
        
        return json
    }
}

extension Array where Element == CSActivity {
    func doMore() -> [CSActivity] {
        return filter { $0.type == .doMore }
    }
    
    func doLess() -> [CSActivity] {
        return filter { $0.type == .doLess }
    }
}
