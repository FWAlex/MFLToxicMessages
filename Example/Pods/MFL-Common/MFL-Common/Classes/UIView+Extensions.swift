//
//  UIView+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

extension UIView {
    
    var x : CGFloat {
        get { return frame.origin.x }
        set { frame.origin.x = newValue }
    }
    
    var y : CGFloat {
        get { return frame.origin.y }
        set { frame.origin.y = newValue }
    }
    
    var width : CGFloat {
        get { return frame.size.width }
        set { frame.size.width = newValue }
    }
    
    var height : CGFloat {
        get { return frame.size.height }
        set { frame.size.height = newValue }
    }
}

extension UIView {
    
    func add (_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}

extension UIView {
    
    static func mfl_viewFromNib(nibName: String, bundle: Bundle? = nil) -> UIView {

        var bundleToUse : Bundle
        
        if let bundle = bundle { bundleToUse = bundle }
        else { bundleToUse = Bundle.main }
        
        let objects = bundleToUse.loadNibNamed(nibName, owner: self, options: nil)
        return objects!.first! as! UIView
    }
    
    static func mfl_viewFromNib(bundle: Bundle? = nil) -> UIView {
        let view = UIView.mfl_viewFromNib(nibName: String(describing: self), bundle: bundle)
        return view
    }
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let localArrangedSubviews = arrangedSubviews
        
        for view in localArrangedSubviews {
            removeArrangedSubview(view)
        }
    }
    
}
