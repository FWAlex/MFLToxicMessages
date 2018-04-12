//
//  MFLInfoView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

protocol MFLInfoViewDelegate : class {
    func infoViewWantsToClose(_ sender: MFLInfoView)
}

@IBDesignable class MFLInfoView : UIView {
    
    weak var delegate : MFLInfoViewDelegate?
    
    var style : Style? { didSet { updateStyle() } }
    var isDismissable = true { didSet { updateIsDismissable() } }
    var image : UIImage? {
        didSet {
            imageView.image = image
            imageContainerView.isHidden = image == nil
        }
    }
    
    fileprivate let textStyle = TextStyle(font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium),
                                          lineHeight: 24)
    
    @IBOutlet fileprivate weak var view : UIView!
    @IBOutlet fileprivate weak var imageView : UIImageView!
    @IBOutlet fileprivate weak var label : UILabel!
    @IBOutlet fileprivate weak var leftButton : RoundedButton!
    @IBOutlet fileprivate weak var bottomButton : RoundedButton!
    @IBOutlet fileprivate weak var leftButtonView : UIView!
    @IBOutlet fileprivate weak var imageContainerView : UIView!
    @IBOutlet fileprivate weak var bottomButtonView: UIView!
    
    var text : String? { didSet { updateText() } }
    var buttonTitle : String? { didSet { updateButtonText() } }
    
    typealias Action = () -> Void
    var action : Action? { didSet { updateAction() } }
    
    init() {
        super.init(frame: CGRect.zero)
        _initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _initialize()
    }
    
    fileprivate func _initialize() {
        
        _ = Bundle.common.loadNibNamed("MFLInfoView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        clipsToBounds = true
    
        imageContainerView.isHidden = true
        updateIsDismissable()
    }
    
    fileprivate func updateIsDismissable() {
        
        let image = UIImage.template(named: "close_white", in: .common)
        leftButton.setImage(isDismissable ? image : nil, for: .normal)
        leftButton.setTitle(isDismissable ? nil : buttonTitle, for: .normal)
        leftButton.backgroundColor = isDismissable ? .clear : style?.textColor4
        
        leftButtonView.isHidden = !isDismissable && action == nil
        bottomButtonView.isHidden = !isDismissable || action == nil
    }
    
    fileprivate func updateStyle() {
        view.backgroundColor = style?.secondary
        updateText()
        leftButton.tintColor = style?.textColor4
        leftButton.backgroundColor = isDismissable ? .clear : style?.textColor4
        bottomButton.backgroundColor = style?.textColor4
        leftButton.setTitleColor(style?.primary, for: .normal)
        bottomButton.setTitleColor(style?.primary, for: .normal)
    }

    fileprivate func updateText() {
        label.attributedText = text?.attributedString(style: textStyle, color: style?.textColor4 ?? .mfl_green)
    }
    
    fileprivate func updateButtonText() {
        leftButton.setTitle(isDismissable ? nil : buttonTitle, for: .normal)
        bottomButton.setTitle(buttonTitle, for: .normal)
    }
    
    fileprivate func updateAction() {
        if action != nil {
            updateIsDismissable()
        } else {
            if isDismissable {
                updateIsDismissable()
            } else {
                leftButtonView.isHidden = true
            }
            bottomButtonView.isHidden = true
        }
    }
    
    @IBAction fileprivate func didTapButton(_ sender: AnyObject) {
        if sender === bottomButton {
            action?()
        } else if sender === leftButton {
            if isDismissable {
                delegate?.infoViewWantsToClose(self)
            } else {
                action?()
            }
        }
    }
}
