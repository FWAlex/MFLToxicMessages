//
//  Bundle+Pod.swift
//  Pods
//
//  Created by Marc Blasi on 30/08/2017.
//
//

import Foundation
import UIKit

class Test {
    
}

extension Bundle {
    
    var displayName: String {
        let name = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return name ?? object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
    }
    
    public class var commonBundle: Bundle {
        return Bundle(for: Test.self)
    }
    
    public class var app : Bundle? {
        return MFLCommon.shared.appBundle
    }
    
    public class var common : Bundle {
        return subspecBundle(named: "Common")
    }
    
    public class var goals : Bundle {
        return subspecBundle(named: "Goals")
    }
    
    public class var mood : Bundle {
        return subspecBundle(named: "Mood")
    }
    
    public class var payment : Bundle {
        return subspecBundle(named: "Payment")
    }
    
    public class var onboarding : Bundle {
        return subspecBundle(named: "Onboarding")
    }
    
    public class var profile : Bundle {
        return subspecBundle(named: "Profile")
    }
    
    public class var grounding : Bundle {
        return subspecBundle(named: "Grounding")
    }
    
    public class var stages : Bundle {
        return subspecBundle(named: "Stages")
    }
    
    public class var questionnaire : Bundle {
        return subspecBundle(named: "Questionnaire")
    }
    
    public class var reflectionSpace : Bundle {
        return subspecBundle(named: "ReflectionSpace")
    }
    
    public class var getMoreHelp : Bundle {
        return subspecBundle(named: "GetMoreHelp")
    }
    
    public class var copingAndSoothing : Bundle {
        return subspecBundle(named: "CopingAndSoothing")
    }
    
    public class var forum : Bundle {
        return subspecBundle(named: "Forum")
    }
    
    public class var toxicMessages : Bundle {
        return subspecBundle(named: "ToxicMessages")
    }
    
    public class var cbm : Bundle {
        return subspecBundle(named: "CBM")
    }
    
    public class func subspecBundle(named name: String) -> Bundle {
        let commonBundle = Bundle.commonBundle
        guard let url = commonBundle.url(forResource: name, withExtension: "bundle"), let bundle = Bundle(url: url) else {
            fatalError("Error getting bundle on subspec named \(name)")
        }
        return bundle
    }
    
    public func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: self, compatibleWith: nil)
    }
}
