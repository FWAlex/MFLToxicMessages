//
//  MFLNavigationBar_Green.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 03/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

open class MFLNavigationBar : UINavigationBar {
    
    open var navigationTitleFont : UIFont { return .systemFont(ofSize: 17, weight: UIFontWeightSemibold) }
    open var navigationTitleColor : UIColor { return .white }
    open var secondaryColor: UIColor { return .white }
    open var primaryColor : UIColor { return .white }
    open var isBarTranslucent : Bool { return false }
    open var backImage : UIImage? { return UIImage() }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    fileprivate func initialize() {
        
        titleTextAttributes = [
            NSFontAttributeName : navigationTitleFont,
            NSForegroundColorAttributeName : navigationTitleColor
        ]
        
        barTintColor = primaryColor
        tintColor = secondaryColor
        isTranslucent = isBarTranslucent
        
        let barButtonAppearance =  UIBarButtonItem.appearance(whenContainedInInstancesOf: [type(of: self)])
        
        let backImage = self.backImage?.stretchableImage(withLeftCapWidth: Int(self.backImage?.size.width ?? 0.0), topCapHeight: 0)
        barButtonAppearance.setBackButtonBackgroundImage(backImage, for: .normal, barMetrics: .default)
    }
}

class MFLNavigationBar_Green: MFLNavigationBar {
    
    override var primaryColor : UIColor { return .mfl_green }
    override var secondaryColor: UIColor { return .white }
}

open class MFLNavigationBar_White: MFLNavigationBar {
    
    override open var navigationTitleColor : UIColor { return .mfl_greyishBrown }
    override open var primaryColor : UIColor { return .white }
    //TODO: Fix this
    override open var secondaryColor: UIColor { return self.secondaryColor }
    override open var backImage: UIImage? { return UIImage(named: "close_white", in: Bundle.commonBundle, compatibleWith: nil) }
}

class MFLNavigationBar_Orange : MFLNavigationBar {
    
    override var primaryColor : UIColor { return .mfl_squash }
}

class MFLNavigationBar_Blue : MFLNavigationBar {
    
    override var primaryColor : UIColor { return .mfl_lightBlue }
}

class MFLNavigationBar_Grey : MFLNavigationBar {
    
    override var primaryColor : UIColor { return .mfl_brownishGrey }
}
