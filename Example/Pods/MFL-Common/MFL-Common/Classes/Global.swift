//
//  Global.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 28/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import UIKit
import AVKit

public struct MFLCommon {
    public static var shared = MFLCommon()
    public var appBundle : Bundle?
    public var navigationBarClassDark : UINavigationBar.Type!
    public var navigationBarClassLight : UINavigationBar.Type!
    public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let topViewController = UIApplication.shared.topViewController() {
            if topViewController is Rotatable {
                return .allButUpsideDown
            }
            
            if topViewController is AVPlayerViewController {
                return .allButUpsideDown
            }
        }
        
        return .portrait
    }
    
    public var counsellingAppAppstoreID : String!
    public var counsellingAppURLScheme : String!
}

let mfl_priceNumberFormatter : NumberFormatter = {
    
    let numberFormatter = NumberFormatter()
    numberFormatter.minimumFractionDigits = 0
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.currencySymbol = "£"
    numberFormatter.numberStyle = .currency
    
    return numberFormatter
}()

public func mfl_nilOrEmpty(_ string: String?) -> Bool {
    
    if let string = string {
        if string.isEmpty { return true }
    } else { return true }
    
    return false
}

public func mfl_nilOrEmpty(attrStr: NSAttributedString?) -> Bool {
    
    if let attrStr = attrStr {
        if attrStr.string.isEmpty { return true }
    } else { return true }
    
    return false
}

func mfl_notEmptyAndEqual(_ string1: String?, _ string2: String?) -> Bool {
    if mfl_nilOrEmpty(string1) { return false }
    if mfl_nilOrEmpty(string2) { return false }
    
    return string1 == string2
}

func mfl_isValid(_ package: UserPackage?) -> Bool {
    guard let package = package else { return false }
    return !package.isExpired
}

func ==(left: CGFloat, right: CGFloat) -> Bool {
    return abs(left - right) < 0.001
}

func *(lhs: CGFloat, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs * rhs.width, height: lhs * rhs.height)
}

extension CGFloat {
    
    static var pi_90 : CGFloat {
        return .pi / 2
    }
    
    static var pi_270 : CGFloat {
        return (3 * .pi) / 2
    }
}
