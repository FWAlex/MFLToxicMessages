//
//  Goal.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol Goal : JSONEncodable {
    var id : String { get }
    var title : String { get set }
    var desc : String { get set }
    var progress : Int { get set }
    var archived: Bool { get set }
    var updatedAt: Date { get set }
    var isExample: Bool { get }
}

extension Goal {
    
    public func json() -> [String : Any] {
        
        var json = [String : Any]()
        
        json["id"] = id
        json["title"] = title
        json["description"] = desc
        json["score"] = progress
        
        return json
    }
}

struct ExampleGoal: Goal {
    let id : String
    var title : String
    var desc : String
    var progress : Int
    var archived: Bool
    var updatedAt: Date
    let isExample: Bool
    
    public static func goals() -> [Goal] {
        
        let example1 = ExampleGoal(id: "-998",
                                   title: NSLocalizedString("Do something for me", comment: ""),
                                   desc: NSLocalizedString("I want to be able to find myself again", comment: ""),
                                   progress: 7,
                                   archived: false,
                                   updatedAt: Date.distantPast,
                                   isExample: true)
        
        let example2 = ExampleGoal(id: "-999",
                                   title: NSLocalizedString("Reconnect with friends", comment: ""),
                                   desc: NSLocalizedString("I want to be able to go out, feel relaxed and enjoy myself", comment: ""),
                                   progress: 4,
                                   archived: false,
                                   updatedAt: Date.distantPast,
                                   isExample: true)
        
        return [example1, example2]
    }
}
