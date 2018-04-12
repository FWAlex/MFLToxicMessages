//
//  StageCell.swift
//  Pods
//
//  Created by Marc Blasi on 26/09/2017.
//
//

import UIKit

final class StageCell: UITableViewCell, NibInstantiable, Reusable {
    
    lazy var stageView: StageView = {
        let stageView = StageView.mfl_viewFromNib(bundle: .stages) as! StageView
        stageView.translatesAutoresizingMaskIntoConstraints = false
        return stageView
    }()
    
    override func layoutSubviews() {
        if self.stageView.superview == nil {
            self.contentView.addSubview(self.stageView)
            self.contentView.topAnchor.constraint(equalTo: self.stageView.topAnchor, constant: 0).isActive=true
            self.contentView.bottomAnchor.constraint(equalTo: self.stageView.bottomAnchor, constant: 0).isActive=true
            self.contentView.leftAnchor.constraint(equalTo: self.stageView.leftAnchor, constant: 0).isActive=true
            self.contentView.rightAnchor.constraint(equalTo: self.stageView.rightAnchor, constant: 0).isActive=true
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted == true {
            stageView.backgroundView.backgroundColor = stageView.leftView.backgroundColor
        }
        else {
            stageView.backgroundView.backgroundColor = .clear
        }
    }
}

