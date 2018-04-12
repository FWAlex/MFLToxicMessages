//
//  MFLRefreshView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 16/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class MFLRefreshView: UIView {

    init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    fileprivate func initialize() {
        setUpStackView()
    }
    
    var spacing : CGFloat {
        get { return stackView.spacing }
        set { stackView.spacing = newValue }
    }
    
    var image : UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }
    
    var attributedText : NSAttributedString? {
        get { return label.attributedText }
        set { label.attributedText = newValue }
    }
    
    var buttonBackgroundColor : UIColor? {
        get { return refreshButton.backgroundColor }
        set { refreshButton.backgroundColor = newValue }
    }
    
    var buttonTitle : String? {
        get { return refreshButton.title(for: .normal) }
        set { refreshButton.setTitle(newValue, for: .normal) }
    }
    
    var buttonBorderColor : UIColor {
        get { return refreshButton.borderColor }
        set { refreshButton.borderColor = newValue }
    }
    
    var buttonTitleFont : UIFont? {
        get { return refreshButton.titleLabel?.font }
        set { refreshButton.titleLabel?.font = newValue }
    }
    
    var buttonTextColor : UIColor? {
        get { return refreshButton.titleLabel?.textColor }
        set { refreshButton.titleLabel?.textColor = newValue }
    }
    
    var refreshImageColor : UIColor? {
        get { return imageView.tintColor }
        set { imageView.tintColor = newValue }
    }
    
    var action : (() -> Void)?
    
    fileprivate var stackView : UIStackView!
    
    fileprivate func setUpStackView() {
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 40
        
        self.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
        
        stackView.addArrangedSubview(self.imageView)
        stackView.addArrangedSubview(self.label)
        stackView.addArrangedSubview(self.refreshButton)
    }
    
    fileprivate lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImageTemplate(named: "refresh_big", in: .common, color: .mfl_green)
        imageView.widthAnchor.constraint(equalToConstant: 122).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 122).isActive = true
        
        return imageView
    }()
    
    fileprivate lazy var label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    fileprivate lazy var refreshButton : RoundedButton = {
        let button = RoundedButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.borderColor = .clear
        button.backgroundColor = .mfl_green
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
        button.titleLabel?.textColor = .white
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.addTarget(self, action: #selector(didTapRefresh(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func didTapRefresh(_ sender: Any) {
        action?()
    }
}
