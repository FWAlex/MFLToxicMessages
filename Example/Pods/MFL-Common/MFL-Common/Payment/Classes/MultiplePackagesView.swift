//
//  PackageView.swift
//  Pods
//
//  Created by Alex Miculescu on 05/09/2017.
//
//

import UIKit

protocol MultiplePackagesViewDelegate : class {
    func packagesView(_ sender: MultiplePackagesView, didSelectPackageAt index: Int)
}

class MultiplePackagesView : UIScrollView {
    
    var style : Style? { didSet { applyStyle() } }
    weak var packagesDelegate : MultiplePackagesViewDelegate?
    
    fileprivate let padding = CGFloat(16)
    fileprivate let itemSpacing = CGFloat(16)
    fileprivate var stackViewHeightConstraint : NSLayoutConstraint?
    fileprivate var lastWidth = CGFloat(0.0)
    fileprivate var selectedView : PackageView?
    
    fileprivate lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = self.itemSpacing
        self.addSubview(stackView)
        
        let views = ["stackView" : stackView]
        let metrics = ["padding" : self.padding]
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[stackView]-(padding)-|", options: [], metrics: metrics, views: views).activate()
        NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: [], metrics: metrics, views: views).activate()
        
        self.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
        
        return stackView
    }()
    
    func set(_ packages: [PackageDisplay]) {
        stackView.removeAllArrangedSubviews()
        packages.forEach { self.addView(for: $0) }
        updateHeightConstraint()
    }
    
    func addView(for package: PackageDisplay) {
        let view = PackageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.package = package
        view.style = style
        stackView.addArrangedSubview(view)

        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -0.5 * (2 * padding + itemSpacing)).isActive = true
    }
    
    func applyStyle() {
        stackView.arrangedSubviews.forEach { ($0 as! PackageView).style = self.style }
    }
    
    func updateHeightConstraint() {
     
        let viewWidth = (width - (2 * padding + itemSpacing)) * 0.5
        
        let maxHeight = stackView.arrangedSubviews.reduce(0.0, { max($0, ($1 as! PackageView).requiredHeightFor(width: viewWidth)) })
        
        stackViewHeightConstraint?.isActive = false
        stackViewHeightConstraint = stackView.heightAnchor.constraint(equalToConstant: maxHeight)
        stackViewHeightConstraint?.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !(lastWidth == width) {
            lastWidth = width
            updateHeightConstraint()
        }
        
    }
}

extension MultiplePackagesView : PackageViewDelegate {
    
    func packageView(_ sender: PackageView, didChangeSelectedSatetTo isSelected: Bool) {
        
        if isSelected {
            selectedView?.isSelected = false
            selectedView = sender
            
            if let index = stackView.arrangedSubviews.index(where: { $0 === sender }) {
                packagesDelegate?.packagesView(self, didSelectPackageAt: index)
            }
        }
    }
}

