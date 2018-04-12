//
//  UIStoryboard+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 27/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    public func viewController<T: UIViewController>() -> T {
        return instantiateViewController(withIdentifier: T.name) as! T
    }
}
