//
//  UserPackage.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public enum SubscriptionStatus {
    case active
    case canceled
}

public protocol UserPackage {
    var packageId : String { get }
    var startDate : Date { get }
    var expiryDate : Date? { get }
    var name : String { get }
    var bundledTokens : Int { get }
    var boltonTokens : Int { get }
    var tokensCount : Int { get }
    var isCanceled : Bool { get }
    
    var pendingSubscriptionId : String? { get }
    var pendingSubscriptionName : String? { get }
    var pendingSubscriptionDesc : String? { get }
    var pendingSubscriptionStatus : SubscriptionStatus? { get }
}

public extension UserPackage {
    
    var tokensCount : Int {
        return bundledTokens + boltonTokens
    }
    
    var isExpired : Bool {
        // If the expiryDate is nil that means that the response from stripe is still pending.
        // We will consider the subscription to be vaid in this case.
        guard let expiryDate = expiryDate else { return false }
        
        return expiryDate < Date()
    }
}

