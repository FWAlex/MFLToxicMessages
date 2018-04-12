//
//  FinkelhorBehavioursCell.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 06/12/2017.
//

import UIKit

enum FinkelhorBehaviourSelectionDisplay {
    case none
    case now
    case past
}

struct FinkelhorBehaviourDisplay {
    var text : String
    var selection : FinkelhorBehaviourSelectionDisplay
}

class FinkelhorBehavioursCell: UITableViewCell, Reusable {

    @IBOutlet fileprivate weak var label: UILabel!
    @IBOutlet fileprivate weak var segmentedControl: UISegmentedControl!
    fileprivate let labelTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium), lineHeight: 24)
    
    var style : Style? { didSet { updateStyle() } }
    var data : FinkelhorBehaviourDisplay? { didSet { updateData() } }
    var action : ((FinkelhorBehaviourSelectionDisplay) -> Void)?
    
    fileprivate func updateStyle() {
        segmentedControl.tintColor = style?.primary
        segmentedControl.backgroundColor = style?.textColor4
        label.attributedText = data?.text.attributedString(style: labelTextStyle,
                                                           color: style?.textColor1 ?? .mfl_greyishBrown)
    }
    
    fileprivate func updateData() {
        label.attributedText = data?.text.attributedString(style: labelTextStyle,
                                                           color: style?.textColor1 ?? .mfl_greyishBrown)
        segmentedControl.setSelection(data?.selection)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
        segmentedControl.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)], for: .normal)
    }

    @IBAction func segmentValueChanged(_ sender: Any) {
        action?(segmentedControl.selection)
    }
}

fileprivate extension UISegmentedControl {
    
    func setSelection(_ selection: FinkelhorBehaviourSelectionDisplay?) {
        switch selection {
        case .some(.now): selectedSegmentIndex = 0
        case .some(.past): selectedSegmentIndex = 1
        default: selectedSegmentIndex = UISegmentedControlNoSegment
        }
    }
    
    var selection : FinkelhorBehaviourSelectionDisplay {
        switch selectedSegmentIndex {
        case 0: return .now
        case 1: return .past
        default: return .none
        }
    }
}
