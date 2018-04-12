//
//  GroundingView.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 26/09/2017.
//

import UIKit

struct GroundingViewTitle {
    var title : NSAttributedString?
    var subtitle: NSAttributedString?
}

enum GroundingViewType {
    case singleText(UIImage?, NSAttributedString?)
    case titled(UIImage?, GroundingViewTitle, NSAttributedString?)
}

class GroundingView : UIView, Identifiable {
    
    
    @IBOutlet fileprivate weak var view: UIView!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subtitleLabel: UILabel!
    @IBOutlet fileprivate weak var textLabel: UILabel!
    @IBOutlet fileprivate weak var titleView: UIView!
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    fileprivate func initialize() {
        _ = Bundle.grounding.loadNibNamed(GroundingView.identifier, owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
    
    var type : GroundingViewType? { didSet { updateType() } }
    
    fileprivate func updateType() {
        guard let type = type else { return }
        
        switch type {
        case .titled(let image, let title, let text):
            imageView.image = image
            titleView.isHidden = false
            titleLabel.attributedText = title.title
            subtitleLabel.attributedText = title.subtitle
            textLabel.attributedText = text

        case .singleText(let image, let text):
            titleView.isHidden = true
            imageView.image = image
            textLabel.attributedText = text
        }
    }
    
    
}
