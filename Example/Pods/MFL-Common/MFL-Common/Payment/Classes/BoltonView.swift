//
//  Bolton.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

struct BoltonDisplay {
    let name: String
    let priceText: String?
}

protocol BoltonViewDelegate : class {
    func boltonView(_ sender: BoltonView, didChangeSelectedSatetTo isSelected: Bool)
}

class BoltonView : UIView, Identifiable {
    
    var bolton : BoltonDisplay? { didSet { updateText() } }
    var style : Style? { didSet { updateStyle() } }
    
    var shouldRemainSelected = true
    var isSelected = false { didSet { animateStateChange() } }
    weak var delegate : BoltonViewDelegate?
    
    fileprivate let animationDuration = TimeInterval(0.3)
    fileprivate let alphaComponent = CGFloat(0.08)
    
    fileprivate var defaultTextColor = UIColor.mfl_greyishBrown
    fileprivate var selectedTextColor = UIColor.mfl_green
    fileprivate var defaultBackgroundColor = UIColor.clear
    fileprivate var defaultBorderColor = UIColor.mfl_lightSlate
    fileprivate var selectedBackgroundColor = UIColor.mfl_green.withAlphaComponent(0.08)
    fileprivate var selectedBorderColor = UIColor.mfl_green
    
    @IBOutlet weak var view: RoundedView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var checkBox: CheckBox!
    
    init(bolton: BoltonDisplay?) {
        self.bolton = bolton
        
        super.init(frame: CGRect.zero)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    func initialize() {
        
        _ = Bundle.payment.loadNibNamed(BoltonView.identifier, owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        view.isExclusiveTouch = true
        
        checkBox.isUserInteractionEnabled = false
        
        updateText()
        updateStyle()
    }
    
    fileprivate func updateStyle() {
        defaultTextColor = style != nil ? style!.textColor1 : .mfl_lifeSlate
        selectedTextColor = style != nil ? style!.primary : .mfl_green
        
        defaultBorderColor = style != nil ? style!.textColor3 : .mfl_lightSlate
        selectedBorderColor = style != nil ? style!.primary : .mfl_green
        
        let color = style != nil ? style!.primary : .mfl_green
        selectedBackgroundColor = color.withAlphaComponent(alphaComponent)
        
        nameLabel.textColor = isSelected ? selectedTextColor : defaultTextColor
        priceLabel.textColor = nameLabel.textColor
        
        checkBox.boxColor = style != nil ? style!.primary : .mfl_green
        checkBox.boxTintColor = style != nil ? style!.primary : .mfl_green
        checkBox.checkColor = style != nil ? style!.textColor4 : .white
        checkBox.borderColor = style != nil ? style!.textColor3 : .mfl_lightSlate
    }

    fileprivate func updateText() {
        nameLabel.text = bolton?.name
        priceLabel.text = bolton?.priceText
    }
    
    @objc fileprivate func viewTapped(_ sender: Any) {
        if isSelected && shouldRemainSelected {
            return
        }
    
        toggleSelectedState()
    }
    
    fileprivate func toggleSelectedState() {
        
        isSelected = !isSelected
        
        animateStateChange()
        
        delegate?.boltonView(self, didChangeSelectedSatetTo: isSelected)
    }
    
    fileprivate func animateStateChange() {
        checkBox.isOn = isSelected
        
        UIView.animate(withDuration: animationDuration) {
            self.nameLabel.textColor = self.isSelected ? self.selectedTextColor : self.defaultTextColor
            self.priceLabel.textColor = self.nameLabel.textColor
            self.view.borderColor = self.isSelected ? self.selectedBorderColor : self.defaultBorderColor
            self.view.backgroundColor = self.isSelected ? self.selectedBackgroundColor : self.defaultBackgroundColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        view.frame = self.bounds
    }
    
}
