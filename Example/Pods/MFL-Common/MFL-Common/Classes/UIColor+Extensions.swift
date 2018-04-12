//
//  UIColor+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 29/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    // Grey
    static var mfl_whiteThree   : UIColor { return UIColor(r: 217, g: 217, b: 217) }
    static var mfl_warmGrey     : UIColor { return UIColor(r: 131, g: 131, b: 131) }
    static var mfl_warmGreyTwo  : UIColor { return UIColor(r: 164, g: 160, b: 160) }//gradient
    static var mfl_lifeSlate    : UIColor { return UIColor(r: 113, g: 112, b: 116) }
    static var mfl_lightSlate   : UIColor { return UIColor(r: 230, g: 231, b: 232) }//seperator
    static var mfl_greyishBrown : UIColor { return UIColor(r: 74,  g: 74,  b: 74)  }
    static var mfl_silver       : UIColor { return UIColor(r: 205, g: 206, b: 210) }
    static var mfl_purpleyGrey  : UIColor { return UIColor(r: 143, g: 142, b: 148) }
//    static var mfl_purpleyGreyTwo : UIColor { return UIColor(r: 147, g: 147, b: 149) }
    static var mfl_brownishGrey : UIColor { return UIColor(r: 102, g: 102, b: 102) }//gradient and navigation
    static var mfl_nearWhite    : UIColor { return UIColor(r: 243, g: 243, b: 243) }
    
    // Blue
    static var mfl_sea          : UIColor { return UIColor(r: 38, g: 188, b: 215)  }
    static var mfl_lightBlue    : UIColor { return UIColor(r: 0,  g: 121, b: 193)  }//gradient and navigation
    
    // Green
    static var mfl_green        : UIColor { return UIColor(r: 109, g: 179, b: 63)  }
    static var mfl_pea          : UIColor { return UIColor(r: 194, g: 205, b: 35)  }//info view
//    static var mfl_peaTwo       : UIColor { return UIColor(r: 191, g: 204, b: 36)  }
    
    // Red
    static var mfl_lollipop     : UIColor { return UIColor(r: 241, g: 95,  b: 124) } //error color
    
    // Yellow
    static var mfl_yellow       : UIColor { return UIColor(r: 194, g: 205, b: 35)  }
    static var mfl_golden       : UIColor { return UIColor(r: 247, g: 194, b: 0)   }//gradient
    
    // Orange
//    static var mfl_rosyPink     : UIColor { return UIColor(r: 250, g: 97,  b: 157) }
//    static var mfl_orange       : UIColor { return UIColor(r: 247, g: 107, b: 28)  }
    static var mfl_squash       : UIColor { return UIColor(r: 247, g: 157, b: 28)  }//gradient and navigation
    
    // Purple
//    static var mfl_sapphire     : UIColor { return UIColor(r: 48,  g: 35,  b: 174) }
//    static var mfl_lavenderPink : UIColor { return UIColor(r: 200, g: 109, b: 215) }
}
