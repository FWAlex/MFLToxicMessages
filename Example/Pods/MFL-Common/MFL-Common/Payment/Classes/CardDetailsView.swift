//
//  CardDetailsView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 01/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

enum SelectedState {
    case number
    case expDate
    case cvc
}

class CardDetailsView : UIView, Identifiable {
    
    fileprivate let animationsDuration = TimeInterval(0.3)
    
//    @IBOutlet var view: UIView!
    
    var selectedState = SelectedState.number {
        didSet {
            
            if self.selectedState == .cvc && (oldValue == .number || oldValue == .expDate) {
                flipCard(toBack: true)
            } else if (self.selectedState == .number || self.selectedState == .expDate) && oldValue == .cvc {
                self.select(self.selectedState, animated: false)
                flipCard(toBack: false)
            } else {
                self.select(self.selectedState, animated: true)
            }
        }
    }
    
    var color = UIColor(r: 177, g: 176, b: 180)
    var textColor = UIColor(r: 177, g: 176, b: 180)
    var cardBackgroundColor = UIColor.white
    var highlightColor = UIColor(r: 177, g: 176, b: 180)
    var shadowColor = UIColor.black
    var shadowOpacity = Float(0.2)
    var shadowOffset = CGSize(width: 0.0, height: 2.0)

    var gradientStartColor = UIColor(r: 255, g: 255, b: 255)
    var gradientEndColor = UIColor(r: 217, g: 217, b: 217)
    
    @IBOutlet weak var cardChipImageView: UIImageView!
    
    fileprivate var frontGradientLayer : CAGradientLayer?
    fileprivate var backGradientLayer : CAGradientLayer?
    
    fileprivate let cornerRadius = CGFloat(4.0)
    fileprivate let borderWidth = CGFloat(1.0)
    
    @IBOutlet fileprivate weak var cardFrontView: UIView!
    @IBOutlet fileprivate weak var cardFrontHighlightView: UIView!
    
    @IBOutlet fileprivate weak var cardBackView: UIView!
    @IBOutlet fileprivate weak var cvcHighlightView: UIView!
    
    @IBOutlet fileprivate weak var cardNumberLabel: UILabel!
    @IBOutlet fileprivate weak var expDateLabel: UILabel!
    
    @IBOutlet fileprivate weak var cvcLabel: UILabel!
    @IBOutlet fileprivate weak var stripView: UIView!
    @IBOutlet fileprivate weak var signatureView: UIView!
    
    @IBOutlet fileprivate weak var numberHighlightConstraint1: NSLayoutConstraint!
    @IBOutlet fileprivate weak var numberHighlightConstraint2: NSLayoutConstraint!
    @IBOutlet fileprivate weak var numberHighlightConstraint3: NSLayoutConstraint!
    @IBOutlet fileprivate weak var numberHighlightConstraint4: NSLayoutConstraint!
   
    fileprivate lazy var numberHighlightConstraints : [NSLayoutConstraint] = {
        
        return [self.numberHighlightConstraint1,
                self.numberHighlightConstraint2,
                self.numberHighlightConstraint3,
                self.numberHighlightConstraint4]
    }()
    
    @IBOutlet fileprivate weak var expDateHighlightConstraint1: NSLayoutConstraint!
    @IBOutlet fileprivate weak var expDateHighlightConstraint2: NSLayoutConstraint!
    @IBOutlet fileprivate weak var expDateHighlightConstraint3: NSLayoutConstraint!
    @IBOutlet fileprivate weak var expDateHighlightConstraint4: NSLayoutConstraint!
    
    fileprivate lazy var expDateHighlightConstraints : [NSLayoutConstraint] = {
      
        return [self.expDateHighlightConstraint1,
                self.expDateHighlightConstraint2,
                self.expDateHighlightConstraint3,
                self.expDateHighlightConstraint4]
    }()
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateUI()
        
        select(selectedState, animated: false)
        cardChipImageView.image = UIImage(named: "card_chip", bundle: .payment)
    }
    
    func updateUI() {
        backgroundColor = .clear
        
        cardFrontView.layer.cornerRadius = cornerRadius
        cardFrontView.backgroundColor = cardBackgroundColor
        cardFrontView.layer.shadowColor = shadowColor.cgColor
        cardFrontView.layer.shadowOffset = shadowOffset
        cardFrontView.layer.shadowOpacity = shadowOpacity
        
        frontGradientLayer?.removeFromSuperlayer()
        frontGradientLayer = newGradinetLayer()
        frontGradientLayer?.frame = cardFrontView.bounds
        cardFrontView.layer.insertSublayer(frontGradientLayer!, at: 0)
        
        cardNumberLabel.textColor = textColor
        expDateLabel.textColor = textColor
        let now = Date()
        let monthStr = now.component(.month) < 10 ? "0\(now.component(.month))" : "\(now.component(.month))"
        expDateLabel.text = monthStr + "/\(now.component(.year) % 100 + 2)"
        
        cardFrontHighlightView.backgroundColor = UIColor.clear
        cardFrontHighlightView.layer.borderColor = highlightColor.cgColor
        cardFrontHighlightView.layer.borderWidth = 1.0
        cardFrontHighlightView.layer.cornerRadius = 4.0
        
        cardBackView.layer.cornerRadius = cornerRadius
        cardBackView.backgroundColor = cardBackgroundColor
        cardBackView.layer.shadowColor = shadowColor.cgColor
        cardBackView.layer.shadowOffset = shadowOffset
        cardBackView.layer.shadowOpacity = shadowOpacity
        
        backGradientLayer?.removeFromSuperlayer()
        backGradientLayer = newGradinetLayer()
        backGradientLayer?.frame = cardBackView.bounds
        cardBackView.layer.insertSublayer(backGradientLayer!, at: 0)
        
        stripView.backgroundColor = color
        
        signatureView.backgroundColor = color
        
        cvcLabel.textColor = textColor
        
        cvcHighlightView.backgroundColor = UIColor.clear
        cvcHighlightView.layer.borderColor = highlightColor.cgColor
        cvcHighlightView.layer.borderWidth = 1.0
        cvcHighlightView.layer.cornerRadius = 4.0
    }
    
    fileprivate func newGradinetLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.cornerRadius = cornerRadius
        
        return gradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frontGradientLayer?.frame = cardFrontView.bounds
        backGradientLayer?.frame = cardBackView.bounds
    }
    
    fileprivate func select(_ state: SelectedState, animated: Bool) {
        
        if animated {
            UIView.animate(withDuration: animationsDuration,
                           animations: {
                self.activateConstraints(for: state)
                self.layoutIfNeeded()
            })
        } else {
            activateConstraints(for: state)
            self.layoutIfNeeded()
        }
    }
    
    func activateConstraints(for state: SelectedState) {
        if state == .expDate {
            NSLayoutConstraint.deactivate(numberHighlightConstraints)
            NSLayoutConstraint.activate(expDateHighlightConstraints)
        } else if state == .number {
            NSLayoutConstraint.deactivate(expDateHighlightConstraints)
            NSLayoutConstraint.activate(numberHighlightConstraints)
        }
    }
    
    fileprivate func flipCard(toBack: Bool) {
        
        var fromView = cardFrontView
        var toView = cardBackView
        var animation = UIViewAnimationOptions.transitionFlipFromRight
        
        if !toBack {
            fromView = cardBackView
            toView = cardFrontView
            animation = UIViewAnimationOptions.transitionFlipFromLeft
        } 
        
        UIView.transition(from: fromView!,
                          to: toView!,
                          duration: animationsDuration,
                          options: [animation, .showHideTransitionViews],
                          completion: nil)
    }
}

