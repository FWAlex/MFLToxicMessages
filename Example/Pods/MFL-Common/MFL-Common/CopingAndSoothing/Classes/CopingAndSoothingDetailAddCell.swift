//
//  CopingAndSoothingDetailAddCell.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 27/10/2017.
//

import UIKit

protocol CopingAndSoothingDetailAddCellDelegate : class {
    func addCell(_ sender: CopingAndSoothingDetailAddCell, wantsToAdd text: String)
}

class CopingAndSoothingDetailAddCell: UITableViewCell, Reusable {
    
    weak var delegate : CopingAndSoothingDetailAddCellDelegate?
    
    @IBOutlet private weak var textField : UITextField!
    @IBOutlet private weak var addButton : UIButton!
    private let placeholder = "Add your own"
    private let placeholderTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium), lineHeight: 24)
    
    var style : Style? { didSet { updateStyle() } }
    
    func updateStyle() {
        textField.attributedPlaceholder = placeholder.attributedString(style: placeholderTextStyle, color: style?.primary ?? .mfl_green)
        textField.textColor = style?.textColor1 ?? .mfl_greyishBrown
        contentView.backgroundColor = style?.textColor3
        updateButtonTintColor()
        updatePlaceholder()
    }
    
    private func setUpAddButton() {
        let plusImage = UIImage.template(named: "plus", in: .common)
        addButton.setBackgroundImage(plusImage, for: .normal)        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(editingDidEndOnExit(_:)), for: .editingDidEndOnExit)
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)
        setUpAddButton()
    }
    
    @IBAction private func didTapAdd(_ sender: Any) {
        endEditing(true)
        if let text = textField.text, text.length > 0 {
            textField.text = nil
            delegate?.addCell(self, wantsToAdd: text)
        }
    }
    
    @objc private func editingChanged(_ sender: Any) {
        updateButtonTintColor()
    }
    
    @objc private func editingDidEndOnExit(_ sender: Any) {
        didTapAdd(addButton)
    }
    
    private func updateButtonTintColor() {
        if let length = textField.text?.length, length > 0 {
            addButton.tintColor = style?.primary
        } else {
            addButton.tintColor = style?.textColor3
        }
    }
    
    private func updatePlaceholder() {
        let attrStr = NSMutableAttributedString(string: self.placeholder)
        let range = NSMakeRange(0, self.placeholder.length)
        let color: UIColor = style?.primary ?? .mfl_green
        attrStr.addAttributes([
            NSForegroundColorAttributeName : color,
            NSFontAttributeName : UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)
            ], range: range)
        
        textField.attributedPlaceholder = attrStr
    }
}

