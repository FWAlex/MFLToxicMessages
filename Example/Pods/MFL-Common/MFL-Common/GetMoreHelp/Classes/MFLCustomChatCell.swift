//
//  MFLCustomChatCell.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 28/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

struct MFLMessage {
    
    let text : String
    let senderName : String
    let senderPlaceholder : String?
    let senderImageURL : String?
    let isOutgoing : Bool
}

@IBDesignable class MFLCustomChatCell: UICollectionViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var senderImage: RoundImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBInspectable var cornerRadius = CGFloat(4.0)
    @IBInspectable var borderWidth = CGFloat(1.0)
    @IBInspectable var borderColor = UIColor.mfl_lightSlate

    fileprivate static let padding = CGFloat(46)
    fileprivate static let messageFont = UIFont.systemFont(ofSize: 17)
    fileprivate static let heightWithoutText = CGFloat(71)
    
    var style : Style? { didSet { updateStyle() } }
    
    static func heightFor(_ text: String, width: CGFloat) -> CGFloat {
        
        let textHeight = text.height(constraintTo: width - padding, font: messageFont)
        
        return textHeight + heightWithoutText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.borderWidth = borderWidth
        containerView.layer.borderColor = borderColor.cgColor
    }
    
    var message : MFLMessage? {
        didSet {
            guard let message = message else { return }
            
            messageLabel.text = message.text
            senderName.text = message.senderName
            set(imageUrl: message.senderImageURL, placeholder: message.senderPlaceholder)
        }
    }
    
    fileprivate func set(imageUrl: String?, placeholder: String?) {
        
        if let url = imageUrl == nil ? nil : URL(string: imageUrl!) {
            senderImage.mfl_setImage(withUrl: url)
        } else {
            senderImage.image = nil
            senderImage.setPlaceholderAsFirstLetter(of: placeholder)
        }
    }
    
    func updateStyle() {
        senderImage.placeholderColor = style?.primary
    }
}
