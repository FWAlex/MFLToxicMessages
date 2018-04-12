//
//  FinkelhorCell.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 27/11/2017.
//

import UIKit

class FinkelhorCell: UITableViewCell, Reusable {

    @IBOutlet fileprivate weak var button: RoundedButton!
    
    var style : Style? { didSet { updateStyle() } }
    var action : (() -> Void)?
    var name : String? { didSet { updateName() } }
    
    private func updateStyle() {
        button.backgroundColor = style?.textColor4
        button.setTitleColor(style?.primary, for: .normal)
    }
    
    private func updateName() {
        button.setTitle(name, for: .normal)
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        action?()
    }
    
}
