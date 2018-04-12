
//
//  UserDefaults+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 17/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

struct PersistentItem {
    var key : String
    var isSecure : Bool
}

fileprivate let emailItem = PersistentItem(key: "mfl_email", isSecure: true)
fileprivate let passwordItem = PersistentItem(key: "mfl_password", isSecure: true)
fileprivate let accessTokenItem = PersistentItem(key: "mfl_accessToken", isSecure: false)
fileprivate let accessTokenExpiryTimeItem = PersistentItem(key: "mfl_accessTokenExpiryTime", isSecure: false)
fileprivate let teamMembersRefreshTimestamp = PersistentItem(key:"mfl_teamMembersRefreshDate", isSecure: false)
fileprivate let packagesRefreshTimestamp = PersistentItem(key:"mfl_packagesRefreshDate", isSecure: false)
fileprivate let sleepDataLastReadTimestamp = PersistentItem(key:"mfl_sleepDataLastReadTimestamp", isSecure: false)
fileprivate let doesUserWantToSendSleepData = PersistentItem(key:"mfl_doesUserWantToSendSleepData", isSecure: false)
fileprivate let didShowCustomSleepRequest = PersistentItem(key:"mfl_didShowCustomSleepRequest", isSecure: false)
fileprivate let shouldFetchSessions = PersistentItem(key:"mfl_shouldFetchSessions", isSecure: false)
fileprivate let didFetchGoalsOnce = PersistentItem(key:"mfl_didFetchGoalsOnce", isSecure: false)
fileprivate let versionDidStagesInstall = PersistentItem(key:"mfl_versionDidStagesInstall", isSecure: false)
fileprivate let cbmUUID = PersistentItem(key:"mfl_cbmUUID", isSecure: false)

public extension UserDefaults {
    
    fileprivate static func mfl_set(value : Any, forItem item : PersistentItem) {
        
        if item.isSecure, let valueString = value as? String {
            KeychainWrapper.standard.set(valueString, forKey: item.key)
        }else{
            standard.set(value, forKey: item.key)
            standard.synchronize()
        }
    }
    
    fileprivate static func mfl_string(forItem item : PersistentItem) -> String? {
        if item.isSecure {
            return KeychainWrapper.standard.string(forKey: item.key)
        }else{
            return standard.string(forKey: item.key)
        }
    }
    
    fileprivate static func mfl_bool(forItem item: PersistentItem) -> Bool? {
        if item.isSecure {
            return KeychainWrapper.standard.bool(forKey: item.key)
        }else{
            return standard.bool(forKey: item.key)
        }
    }
    
    fileprivate static func mfl_integer(forItem item: PersistentItem) -> Int? {
        if item.isSecure {
            return KeychainWrapper.standard.integer(forKey: item.key)
        }else{
            return standard.integer(forKey: item.key)
        }
    }
    
    fileprivate static func mfl_double(item: PersistentItem) -> Double? {
        if item.isSecure {
            return KeychainWrapper.standard.double(forKey: item.key)
        }else{
            return standard.double(forKey: item.key)
        }
    }
    
    fileprivate static func mfl_delete(item : PersistentItem){
        
        if item.isSecure {
            KeychainWrapper.standard.removeObject(forKey: item.key)
        }else{
            standard.removeObject(forKey: item.key)
        }
    }
    
    //MARK - Exposed
    public static var mfl_email : String? {
        set {
            if newValue != nil {
                mfl_set(value: newValue!, forItem: emailItem)
            }
        }
        get { return self.mfl_string(forItem: emailItem) }
    }
    
    public static var mfl_password : String? {
        set {
            if newValue != nil {
                mfl_set(value: newValue!, forItem: passwordItem)
            }
        }
        get { return self.mfl_string(forItem: passwordItem) }
    }
    
    public static var mfl_isUserLoggedIn : Bool {
        guard let accessToken = mfl_accessToken else { return false }
        
        return !accessToken.isEmpty
    }
    
    public static var mfl_accessToken : String? {
        set {
            if let accessToken = newValue {
                mfl_set(value: accessToken, forItem: accessTokenItem)
            }
        }
        get { return mfl_string(forItem: accessTokenItem) }
    }
    
    public static var mfl_accessTokenExpiryTime : TimeInterval? {
        set {
            if let expTime = newValue {
                mfl_set(value: expTime, forItem: accessTokenExpiryTimeItem)
            }
        }
        
        get {
            if let time = mfl_integer(forItem: accessTokenExpiryTimeItem) {
                return TimeInterval(time)
            } else {
                return nil
            }
        }
    }
    
    public static var mfl_teamMembersRefreshDate : Date {
        get {
            let timestamp = mfl_double(item: teamMembersRefreshTimestamp)
            if let timestamp = timestamp {
                return Date(timeIntervalSince1970: TimeInterval(timestamp))
            } else {
                return Date()
            }
        }
        set { mfl_set(value: Double(newValue.timeIntervalSince1970), forItem: teamMembersRefreshTimestamp) }
    }
    
    public static var mfl_packagesRefreshDate : Date {
        get {
            let timestamp = mfl_double(item: packagesRefreshTimestamp)
            if let timestamp = timestamp {
                return Date(timeIntervalSince1970: TimeInterval(timestamp))
            } else {
                return Date()
            }
        }
        set { mfl_set(value: Double(newValue.timeIntervalSince1970), forItem: packagesRefreshTimestamp) }
    }
    
    public static var mfl_sleepDataLastReadDate : NSDate? {
        get {
            let timestamp = mfl_double(item: sleepDataLastReadTimestamp)
            if let timestamp = timestamp {
                return NSDate(timeIntervalSince1970: TimeInterval(timestamp))
            } else {
                return nil
            }
        }
        set {
            if let date = newValue {
                mfl_set(value: Double(date.timeIntervalSince1970), forItem: sleepDataLastReadTimestamp)
            }
        }
    }
    
    public static var mfl_doesUserWantToSendSleepData : Bool {
        get { return mfl_bool(forItem: doesUserWantToSendSleepData) ?? false }
        set { mfl_set(value: newValue, forItem: doesUserWantToSendSleepData) }
    }
    
    public static var mfl_didShowCustomSleepRequest : Bool {
        get { return mfl_bool(forItem: didShowCustomSleepRequest) ?? false }
        set { mfl_set(value: newValue, forItem: didShowCustomSleepRequest) }
    }
    
    public static var mfl_shouldFetchSessions : Bool {
        get { return mfl_bool(forItem: shouldFetchSessions) ?? false }
        set { mfl_set(value: newValue, forItem: shouldFetchSessions) }
    }
    
    public static var mfl_didFetchGoalsOnce : Bool {
        get { return mfl_bool(forItem: didFetchGoalsOnce) ?? false }
        set { mfl_set(value: newValue, forItem: didFetchGoalsOnce) }
    }
    
    public static var mfl_versionDidStagesInstall : String {
        get { return mfl_string(forItem: versionDidStagesInstall) ?? "" }
        set { mfl_set(value: newValue, forItem: versionDidStagesInstall) }
    }
    
    public static var mfl_cbmUUID : String? {
        get { return mfl_string(forItem: cbmUUID) }
        set { mfl_set(value: newValue, forItem: cbmUUID) }
    }
    
    public static func mfl_removeAll() {
        _ = KeychainWrapper.standard.removeAllKeys()
        
        if let bundleId = Bundle.main.bundleIdentifier {
            standard.removePersistentDomain(forName: bundleId)
        }
        
    }
}
