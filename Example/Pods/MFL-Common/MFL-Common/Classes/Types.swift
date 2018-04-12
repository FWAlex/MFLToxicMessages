//
//  Types.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 26/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public enum UpdateResult<T> {
    case success(T)
    case failure(Error, T?) // includes existing value on failure
}

public enum DurationUnit : String {
    case month
    case year
}

extension DurationUnit {
    
    func dateFrom(_ date: Date, numberOfUnits: Int) -> Date {
        
        switch self {
        case .month: return date.dateByAdding(months: numberOfUnits)
        case .year: return date.dateByAdding(years: numberOfUnits)
        }
    }
}

public struct AlertText {
    let title : String
    let message : String
}

//MARK: - Rotate
protocol Rotatable {
    var supprotedInterfaceOrientations : UIInterfaceOrientationMask { get }
}

//MARK: - Payment
public protocol Payable {
    var id : String { get }
    var name : String { get }
    var price : Double { get }
}

//MARK: - Identifiable
public protocol Identifiable : class {
    
    static var identifier : String { get }
}

extension Identifiable {
    static var identifier : String {
        return String(describing: self)
    }
}

//MARK: - NibInstantiable
public protocol NibInstantiable: class {
    static func nib(in bundle: Bundle) -> UINib
    static func instanceFromNib(in bundle: Bundle) -> Self
}

extension NibInstantiable {
    static func nib(in bundle: Bundle) -> UINib {
        return UINib(nibName: String(describing: Self.self), bundle: bundle)
    }
    
    static func instanceFromNib(in bundle: Bundle) -> Self {
        let instantiatedViews = Self.nib(in: bundle).instantiate(withOwner: nil, options: nil)
        guard instantiatedViews.count > 0,
            let view = instantiatedViews[0] as? UIView else { fatalError("Cannot instantiate view from nib") }
        return view as! Self
    }
}

//MARK: - Reusable
/// This protocol describes a class that has a reusable Id.
protocol Reusable: class {
    /// The reuse ID for the class
    static var reuseID: String { get }
}

/// Shared implementation of the protocol
extension Reusable {
    static var reuseID: String { return String(describing: Self.self) }
}

//MARK: - JSON
public typealias Metadata = [String : Any]

public protocol JSONDecodable {
    init?(json: MFLJson)
}

public protocol JSONEncodable {
    func json() -> [String : Any]
}

protocol ParametersConvertible {
    var parameters : [String: Any] {get}
}

protocol FormDecodable {
    init?(form: [String:Any])
}

//MARK: - States

protocol Priority {
    var priority : Int { get }
}

class States<T: Priority> {
    
    fileprivate let states = NSMutableOrderedSet()
    
    func add(_ state: T) {
        states.add(state)
        sort()
    }
    
    fileprivate func sort() {
        states.sort(comparator: {
            if let one = $0 as? T, let two = $1 as? T {
                return one.priority > two.priority ? ComparisonResult.orderedAscending : ComparisonResult.orderedDescending
            }
            return ComparisonResult.orderedDescending
        })
    }
    
    var topPriority : T? {
        if states.count == 0 { return nil }
        return states.object(at: 0) as? T
    }
    
    func remove(_ state: T) {
        states.remove(state)
    }
}

//MARK: - Math

typealias Degrees = CGFloat

extension Degrees {
    var radians : CGFloat {
        return self * .pi / 180.0
    }
}

//MARK: - Notifications

public let MFLLogoutNotification               = Notification.Name("MFLLogoutNotification")

public let MFLShouldFetchSessionsNotification  = Notification.Name("MFLShouldFetchSessionsNotification")
public let MFLDidFetchSessionsNotification     = Notification.Name("MFLDidFetchSessionsNotification")
public let MFLSessionShouldStartNotification   = Notification.Name("MFLSessionShouldStartNotification")
public let MFLDidReceiveSession                = Notification.Name("MFLDidReceiveSession")

public let MFLSubscriptionDidFinish            = Notification.Name("MFLSubscriptionDidFinish")
public let MFLDidReceiveQuestionnaire          = Notification.Name("MFLDidReceiveQuestionnaire")
public let MFLTherapistDidCancelQuestionnaire  = Notification.Name("MFLTherapistDidCancelQuestionnaire")
public let MFLDidCompleteQuestionnaire         = Notification.Name("MFLDidCompleteQuestionnaire")

//MARK: - Int

extension Int {
    var cgFloat : CGFloat {
        return CGFloat(self)
    }
}
