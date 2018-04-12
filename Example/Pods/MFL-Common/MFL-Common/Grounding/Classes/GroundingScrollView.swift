//
//  GroundingScrollView.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 27/09/2017.
//

import UIKit

class GroundingScrollView : UIScrollView {
    
    fileprivate let interItemSpacing = CGFloat(8.0)
    
    fileprivate lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = self.interItemSpacing
        self.addSubview(stackView)
        
        let views = ["stackView" : stackView]
        let metrics = ["spacing" : self.interItemSpacing / 2]
        NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: [], metrics: nil, views: views).activate()
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-(spacing)-[stackView]-(spacing)-|", options: [], metrics: metrics, views: views).activate()
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    fileprivate func initialize() {
        
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        clipsToBounds = false
    }
    
    func set(items: [GroundingViewType]) {
        
        stackView.removeAllArrangedSubviews()
        
        for item in items {
            
            let view = GroundingView()
            view.type = item
            view.translatesAutoresizingMaskIntoConstraints = false
            add(view)
        }
    }
    
    fileprivate func add(_ view: UIView) {
        stackView.addArrangedSubview(view)
        view.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0, constant: -interItemSpacing).isActive = true
    }
}
