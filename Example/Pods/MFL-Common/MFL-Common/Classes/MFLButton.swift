//
//  MFLButton.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 01/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

public class MFLButton : UIButton {
    
    @IBInspectable var shouldTrackTap = false
    
    typealias BtnAction = () -> Void
    var btnAction : BtnAction?
    
    convenience init(action: BtnAction? = nil) {
        self.init(frame: CGRect.zero)
        
        btnAction = action
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    fileprivate func initialize() {
        addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc fileprivate func buttonTapped(_ sender: Any) {
        if shouldTrackTap { MFLAnalytics.record(event: .buttonTap(name: title(for: .normal) ?? "", value: nil)) }
        btnAction?()
    }
    
}
