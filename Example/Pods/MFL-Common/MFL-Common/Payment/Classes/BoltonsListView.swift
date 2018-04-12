//
//  BoltonsListView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

protocol BoltonsListViewDelegate : class {
    func boltonsListView(_ sender: BoltonsListView, didSelectBoltonAt index: Int)
}

class BoltonsListView: UIStackView {
    
    weak var listDelegate : BoltonsListViewDelegate?
    var style : Style? { didSet { updateStyle() } }
    
    fileprivate var selectedView : BoltonView?
    fileprivate var views = [BoltonView]()
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    fileprivate func initialize() {
        axis = .vertical
        spacing = 16
    }
    
    func set(_ boltons: [BoltonDisplay]) {
        
        setInitialState()
        createViews(for: boltons)
    }
    
    fileprivate func setInitialState() {
        removeAllArrangedSubviews()
        selectedView = nil
        views = [BoltonView]()
    }
    
    fileprivate func createViews(for boltons: [BoltonDisplay]) {
        
        for bolton in boltons {
            let view = BoltonView(bolton: bolton)
            view.delegate = self
            view.style = style
            views.append(view)
            addArrangedSubview(view)
        }
    }
    
    fileprivate func updateStyle() {
        views.forEach { $0.style = style }
    }
}

extension BoltonsListView : BoltonViewDelegate {
    
    func boltonView(_ sender: BoltonView, didChangeSelectedSatetTo isSelected: Bool) {
        
        if isSelected {
            selectedView?.isSelected = false
            selectedView = sender
            
            if let index = views.index(where: { $0 === sender }) {
                listDelegate?.boltonsListView(self, didSelectBoltonAt: index)
            }
        }
    }
}
