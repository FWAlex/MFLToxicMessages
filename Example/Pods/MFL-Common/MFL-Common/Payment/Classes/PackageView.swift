//
//  PackageView.swift
//  Pods
//
//  Created by Alex Miculescu on 05/09/2017.
//
//

import UIKit

struct PackageDisplay {
    let name : String
    let price : Double
    let durationUnit : DurationUnit
}

protocol PackageViewDelegate : class {
    func packageView(_ sender: PackageView, didChangeSelectedSatetTo isSelected: Bool)
}

class PackageView : UIView, Identifiable {
    
    weak var delegate : PackageViewDelegate?
    
    @IBOutlet fileprivate weak var view: RoundedView!
    @IBOutlet fileprivate weak var checkbox: CheckBox!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var priceLabel: UILabel!
    @IBOutlet fileprivate weak var unitLabel: UILabel!
    
    fileprivate let nameTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium), lineHeight: 28)
    
    var style : Style? { didSet { updateStyle() } }
    var package : PackageDisplay? { didSet { updateText() } }
    
    var shouldRemainSelected = true
    var isSelected = false { didSet { animateStateChange() } }
    
    fileprivate let animationDuration = TimeInterval(0.3)
    fileprivate let alphaComponent = CGFloat(0.08)
    
    fileprivate var defaultTextColor = UIColor.mfl_greyishBrown
    fileprivate var selectedTextColor = UIColor.mfl_green
    fileprivate var defaultBackgroundColor = UIColor.clear
    fileprivate var defaultBorderColor = UIColor.mfl_lightSlate
    fileprivate var selectedBackgroundColor = UIColor.mfl_green.withAlphaComponent(0.08)
    fileprivate var selectedBorderColor = UIColor.mfl_green
    
    
    init() {
        super.init(frame: .zero)
        
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    fileprivate func initialize() {
        backgroundColor = .clear
        
        _ = Bundle.payment.loadNibNamed(PackageView.identifier, owner: self, options: nil)
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        view.isExclusiveTouch = true
        
        checkbox.isUserInteractionEnabled = false
        
        updateStyle()
        updateText()
    }
    
    fileprivate func updateStyle() {
        defaultTextColor = style != nil ? style!.textColor1 : .mfl_lifeSlate
        selectedTextColor = style != nil ? style!.primary : .mfl_green
        
        defaultBorderColor = style != nil ? style!.textColor3 : .mfl_lightSlate
        selectedBorderColor = style != nil ? style!.primary : .mfl_green
        view.borderColor = isSelected ? selectedBorderColor : defaultBorderColor
        
        let color = style != nil ? style!.primary : .mfl_green
        selectedBackgroundColor = color.withAlphaComponent(alphaComponent)
        
        updateNameText()
        priceLabel.textColor = isSelected ? selectedTextColor : defaultTextColor
        unitLabel.textColor = priceLabel.textColor
        
        checkbox.boxColor = style != nil ? style!.primary : .mfl_green
        checkbox.boxTintColor = style != nil ? style!.primary : .mfl_green
        checkbox.checkColor = style != nil ? style!.textColor4 : .white
        checkbox.borderColor = style != nil ? style!.textColor3 : .mfl_lightSlate
    }
    
    func updateNameText() {
        nameLabel.attributedText = package?.name.attributedString(style: nameTextStyle,
                                                                   color: isSelected ? selectedTextColor : defaultTextColor,
                                                                   alignment: .center)
    }
    
    fileprivate func updateText() {
        updateNameText()
        if let package = package {
            priceLabel.text = mfl_priceNumberFormatter.string(from: NSNumber(value: package.price))
            unitLabel.text = package.durationUnit.display
        }
        
        view.layoutIfNeeded()
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
        
        delegate?.packageView(self, didChangeSelectedSatetTo: isSelected)
    }
    
    fileprivate func animateStateChange() {
        checkbox.isOn = isSelected
        
        UIView.animate(withDuration: animationDuration) {
            self.updateNameText()
            self.priceLabel.textColor = self.isSelected ? self.selectedTextColor : self.defaultTextColor
            self.unitLabel.textColor = self.priceLabel.textColor
            self.view.borderColor = self.isSelected ? self.selectedBorderColor : self.defaultBorderColor
            self.view.backgroundColor = self.isSelected ? self.selectedBackgroundColor : self.defaultBackgroundColor
        }
    }
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }
    
    func requiredHeightFor(width: CGFloat) -> CGFloat {

        var height = CGFloat(16 + 16 + 24 + 6 + 12)
        
        height += nameLabel.attributedText?.height(constraintTo: width - (16 + 16)) ?? 0.0
        height += priceLabel.text?.height(constraintTo: width - (16 + 16), font: priceLabel.font) ?? 0.0
        height += unitLabel.text?.height(constraintTo: width - (16 + 16), font: unitLabel.font) ?? 0.0
        
        return height
    }
}

fileprivate extension DurationUnit {
    var display : String {
        
        switch  self {
        case .month: return NSLocalizedString("per month", comment: "")
        case .year: return NSLocalizedString("per year", comment: "")
        }
    }
}
