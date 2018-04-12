//
//  StageMenuView.swift
//  Alamofire
//
//  Created by Marc Blasi on 22/09/2017.
//

import UIKit

protocol StageMenuViewDataSource {
    
}

protocol StageMenuViewDelegate {
    
}

class StageMenuView: UIView {
    var delegate: StageMenuViewDelegate?
    var dataSource: StageMenuViewDataSource?
    
    func reload() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        
    }
    
//    fileprivate var
}
