//
//  ReflectionSpaceItemCell.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 05/10/2017.
//

import UIKit
import AVFoundation

struct ReflectionSpaceItemDisplay {
    let image : UIImage?
    let isVideo : Bool
}

class ReflectionSpaceItemCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var playIcon: PlayIcon!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var checkBox: CheckBox!
    @IBOutlet fileprivate weak var overlayView: RoundedView!
    
    var isSelectable : Bool = false { didSet { updateIsSelectable() } }
    fileprivate var _isSelected = false
    
    
    var item : ReflectionSpaceItemDisplay? {
        didSet {
            imageView.image = item?.image
            playIcon.isHidden = !(item?.isVideo ?? false)
        }
    }
    
    var style: Style? { didSet { updateStyle() } }
    
    fileprivate func updateStyle() {
        playIcon.color = style?.primary ?? .mfl_green
        checkBox.backgroundColor = .clear
        checkBox.checkColor = style?.textColor4 ?? .white
        checkBox.boxColor = style?.primary ?? .mfl_green
        checkBox.boxTintColor = style?.primary ?? .mfl_green
        checkBox.borderColor = style?.textColor3 ?? .mfl_silver
        setSelected(_isSelected, animated: true)
    }
    
    fileprivate func updateIsSelectable() {
        overlayView.alpha = isSelectable ? 1.0 : 0.0
    }
    
    func setSelected(_ isSelected: Bool, animated: Bool) {
        _isSelected = isSelected
        overlayView.backgroundColor = _isSelected ? style?.primary.withAlphaComponent(0.3) : .clear
        overlayView.borderColor = _isSelected ? style?.primary ?? .mfl_green : style?.textColor3 ?? .mfl_silver
        checkBox.setOn(_isSelected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 4.0
        self.overlayView.alpha = 0.0
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playIcon.layer.cornerRadius = playIcon.width / 2.0
    }
    
    override func prepareForReuse() {
        /* Empty */
    }
}
