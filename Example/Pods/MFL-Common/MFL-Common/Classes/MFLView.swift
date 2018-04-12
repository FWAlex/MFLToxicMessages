//
//  MFLView.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 05/02/2018.
//

import UIKit

class MFLView : UIView {
    
    private var view : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize(bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize(bundle: nil)
    }
    
    func initialize(bundle: Bundle?) {
        initialize(bundle: bundle, nibName: nil)
    }
    
    func initialize(bundle: Bundle?, nibName: String?) {
        
        backgroundColor = .clear
        
        let nibName = nibName ?? String(describing: type(of: self))
        view = (bundle ?? Bundle.common).loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
        
        guard let view = view else { return }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view" : view]).activate()
        NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view" : view]).activate()
    }
}
