//
//  Analytics.swift
//  MFLHalsa
//
//  Created by Jonathan Flintham on 21/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import PiwikTracker

public protocol AnalyticsWorker : class {
    func record(state: MFLAnalytics.State)
    func record(event: MFLAnalytics.Event)
}

class ConsoleWorker: AnalyticsWorker {
    func record(state: MFLAnalytics.State) { debugPrint("State: \(state)") }
    func record(event: MFLAnalytics.Event) { debugPrint("Event: \(event.info)") }
}

public class PiwikWorker : AnalyticsWorker {
    
    public init(siteID: String, baseURL: URL?) {
        if let baseURL = baseURL {
            PiwikTracker.configureSharedInstance(withSiteID: siteID, baseURL: baseURL)
        }
    }
    
    public func record(state: MFLAnalytics.State) { PiwikTracker.shared?.track(view: ["\(state)"]) }
    public func record(event: MFLAnalytics.Event) {
        PiwikTracker.shared?.track(eventWithCategory: event.info.category.rawValue,
                                   action: event.info.action.rawValue,
                                   name: event.info.name,
                                   value: event.info.value?.floatValue)
    }
}

public class MFLAnalytics {
    
    private static var workers = [AnalyticsWorker]()
    
    public static func add(_ worker: AnalyticsWorker) {
        workers.append(worker)
    }
    
    public static func remove(_ worker: AnalyticsWorker) {
        workers.remove(where: { $0 === worker })
    }
    
    static func startWorkers() {
        _ = workers
    }
    
    public static func record(state: MFLAnalytics.State) {
        workers.forEach { $0.record(state: state) }
    }
    
    public static func record(event: MFLAnalytics.Event) {
        workers.forEach { $0.record(event: event) }
    }
    
    public enum State: String, CustomStringConvertible {
        case login = "Login"
        
        public var description: String {
            return self.rawValue
        }
    }
    
    public enum Event: CustomStringConvertible {
        case buttonTap(name: String, value: NSNumber?)
        case thresholdPassed(name: String)
        case paymentConfirmation(name: String, currency: String, value: NSNumber?)
        case paymentFailed(name: String)
        
        public var info: EventInfo {
            switch self {
            case .buttonTap(let name, let value): return EventInfo(category: .ui, action: .buttonTap, name: name, value: value)
            case .thresholdPassed(let name): return EventInfo(category: .ui, action: .thresholdPassed, name: name)
            case .paymentConfirmation(let name, _, let value): return EventInfo(category: .payment, action: .payment, name: name, value: value)
            case .paymentFailed(let name): return EventInfo(category: .payment, action: .payment, name: name, value: nil)
            }
        }
        
        public var description: String {
            return "\(info)"
        }
    }
}

public struct EventInfo: CustomStringConvertible {
    let category: EventCategory
    let action: EventAction
    let name: String
    let value: NSNumber?
    
    init(category: EventCategory, action: EventAction, name: String, value: NSNumber? = nil) {
        self.category = category
        self.action = action
        self.name = name
        self.value = value
    }
    
    var nonNilValue: NSNumber {
        return value ?? NSNumber(integerLiteral: -1)
    }
    
    public var description: String {
        return "Event: \(category.rawValue), \(action.rawValue), \(name), \(String(describing: nonNilValue))"
    }
}

enum EventCategory: String {
    case ui
    case payment
}

enum EventAction: String {
    case buttonTap
    case thresholdPassed
    case payment
}
