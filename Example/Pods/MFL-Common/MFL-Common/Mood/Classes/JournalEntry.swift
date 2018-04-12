//
//  JournalEntry.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 04/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public protocol JournalEntry {
    var emotion : Emotion { get set }
    var reason : String? { get set }
    var moodTags : [String]? { get }
    var dateCreated : Date { get }
}

public enum Emotion {
    case happy
    case neutral
    case sad
    
    public func toString() -> String {
        switch self {
        case .happy: return "happy"
        case .neutral: return "neutral"
        case .sad: return "sad"
        }
    }
}
