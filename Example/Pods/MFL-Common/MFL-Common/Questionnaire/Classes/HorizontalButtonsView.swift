//
//  HorizontalButtonsView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

fileprivate let interItemSpacing = CGFloat(20)

protocol HorizontalButtonsViewDelegate : class {
    func horizontalButtonsView(_ sender: HorizontalButtonsView, didSelect item: String, at index: Int)
}

class HorizontalButtonsView : UIView {
    
    weak var delegate : HorizontalButtonsViewDelegate?
    
    var buttonsBackgroundColor = UIColor.white
    var buttonsBorderColor = UIColor.mfl_lightSlate
    var buttonsTitleColor = UIColor.mfl_greyishBrown
    var buttonsTitleFont = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightMedium)
    
    fileprivate var buttons = [UIButton]()
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        self.addSubview(scrollView)
        
        let views = ["scrollView" : scrollView]
        NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: nil, views: views).activate()
        NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: views).activate()
        
        return scrollView
    }()
    
    fileprivate lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = interItemSpacing
        
        self.scrollView.addSubview(stackView)
        
        let views = ["stackView" : stackView]
        NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: [], metrics: nil, views: views).activate()
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[stackView]-14-|", options: [], metrics: nil, views: views).activate()
        
        return stackView
    }()
    
    func set(items: [String]) {
        
        for button in buttons {
            stackView.removeArrangedSubview(button)
        }
        
        buttons = [UIButton]()
        
        for item in items {
            let button = newButton(title: item)
            button.addTarget(self, action: #selector(HorizontalButtonsView.buttonTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    func newButton(title: String?) -> UIButton {
        let button = RoundedButton()
        button.setTitle(title, for: .normal)
        button.borderColor = buttonsBorderColor
        button.backgroundColor = buttonsBackgroundColor
        button.setTitleColor(buttonsTitleColor, for: .normal)
        button.titleLabel?.font = buttonsTitleFont
        
        
        return button
    }
    
    @objc fileprivate func buttonTapped(_ sender: UIButton) {
        
        let index = buttons.index(of: sender)!
        delegate?.horizontalButtonsView(self, didSelect: sender.titleLabel!.text!, at: index)
    }
}
