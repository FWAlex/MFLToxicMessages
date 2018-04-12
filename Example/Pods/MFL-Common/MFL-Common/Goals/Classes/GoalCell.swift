//
//  GoalCell.swift
//  MFLHalsa
//
//  Created by Jonathan Flintham on 31/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

final class GoalCell: UITableViewCell, Reusable, NibInstantiable {

    static let inset: CGFloat = 8
    
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var detailLabel: UILabel!
    @IBOutlet fileprivate weak var goalLevelImageView: UIImageView!
    @IBOutlet fileprivate weak var goalLevelLabel: UILabel!
    
    fileprivate lazy var exampleBannerView: ExampleBannerView = {
        return ExampleBannerView()
    }()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var desc: String? {
        didSet {
            detailLabel.text = desc
        }
    }
    
    var progress: Int = 0 {
        didSet {
            goalLevelLabel.text = "\(progress)"
        }
    }
    
    var isExample: Bool = false {
        didSet {
            exampleBannerView.isHidden = !isExample
        }
    }
    
    var style : Style? { didSet { updateStyle() } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        refreshBackgroundColor(animated: false)
        
        containerView.layer.cornerRadius = 4
        
        containerView.addSubview(exampleBannerView)
        exampleBannerView.widthAnchor.constraint(equalToConstant: 66).isActive = true
        exampleBannerView.heightAnchor.constraint(equalToConstant: 66).isActive = true
        exampleBannerView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        exampleBannerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        goalLevelImageView.image = UIImage(named: "goalRate", bundle: MFLCommon.shared.appBundle)
        
        updateStyle()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        refreshBackgroundColor(animated: animated)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        refreshBackgroundColor(animated: animated)
    }
    
    private func refreshBackgroundColor(animated: Bool) {
        
        let refresh = {
            self.containerView.backgroundColor = self.isHighlighted || self.isSelected ? .mfl_nearWhite : .white
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) { refresh() }
        } else {
            refresh()
        }
    }
    
    private func updateStyle() {
        titleLabel.textColor = style != nil ? style!.textColor1 : .mfl_greyishBrown
        detailLabel.textColor = style != nil ? style!.textColor2 : .mfl_lifeSlate
        goalLevelLabel.textColor = style != nil ? style!.textColor4 : .white
        exampleBannerView.style = style
    }
}
