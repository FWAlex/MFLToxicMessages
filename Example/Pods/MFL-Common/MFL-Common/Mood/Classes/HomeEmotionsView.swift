//
//  HomeEmotionsView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 29/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

protocol HomeEmotionsViewDelegate : class {
    func homeEmotionsView(_ sender: HomeEmotionsView, didSelect emotion: Emotion)
}

public class HomeEmotionsView: UIView {

    weak var delegate : HomeEmotionsViewDelegate?
    
    var style : Style? {
        didSet {
            updateStyle()
        }
    }
    
    fileprivate let multiplier = CGFloat(2.0)
    fileprivate let animationsDuration = TimeInterval(0.3)
    fileprivate let messageLabelPadding = CGFloat(38)
    fileprivate let messageLabelTopSpacing = CGFloat(23)
    fileprivate var highlightedEmotion : Emotion?
    
    @IBOutlet fileprivate var happyView : UIButton!
    @IBOutlet fileprivate var neutralView : UIButton!
    @IBOutlet fileprivate var sadView : UIButton!
    @IBOutlet fileprivate var titlesView : UIStackView!
    @IBOutlet fileprivate var disclaimerLabel : UILabel!
    
    fileprivate lazy var allViews : [UIView] = {
        return [self.happyView, self.neutralView, self.sadView, self.titlesView, self.disclaimerLabel]
    }()
    
    fileprivate lazy var animatedPlaceholder : UIButton = {
        let view = UIButton()
        view.isUserInteractionEnabled = false
        self.addSubview(view)
        return view
    }()
    
    fileprivate lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        self.addSubview(label)
        
        return label
    }()
    
    fileprivate func updateStyle() {
        guard let style = style else { return }
        disclaimerLabel.attributedText = disclaimerLabel.attributedText?.attributedString(style: .smallText, color: style.textColor4, alignment: .center)
        messageLabel.attributedText = TextStyle.bigText.attributedString(with: "Thanks for letting us know how you feel", color: style.textColor4, alignment: .center)
    }
    
    func setUpAnimationBeginState(for emotion: Emotion) {
        setAllViews(enabled: false)
        highlightedEmotion = emotion
        
        animatedPlaceholder.isHidden = false
        animatedPlaceholder.setBackgroundImage(emotion.image, for: .normal)
        positionPlaceholder(with: emotion)
        
        messageLabel.alpha = 1.0
        messageLabel.isHidden = false
        positionMessageLabel()
        
        hideAllViews()
    }

    func animateToDefault(completion: (() -> Void)?) {
        guard let emotion = highlightedEmotion else { return }
        
        UIView.animate(withDuration: animationsDuration,
                       animations: {
                        self.showAllViews(exept: emotion)
                        
                        self.messageLabel.alpha = 0.0
                        
                        let view = self.view(for: emotion)
                        self.animatedPlaceholder.frame = view.convert(view.bounds, to: self)
        }, completion: { _ in
            self.view(for: emotion).alpha = 1.0
            self.animatedPlaceholder.isHidden = true
            self.messageLabel.isHidden = true
            self.highlightedEmotion = nil
            self.setAllViews(enabled: true)
            completion?()
        })
    }
    
    @IBAction fileprivate func didTapEmotion(_ sender: UIButton) {
        
        var emotion: Emotion? = nil
        
        switch sender {
        case happyView: emotion = .happy
        case neutralView: emotion = .neutral
        case sadView: emotion = .sad
        default: break
        }
        
        guard let safeEmotion = emotion else { return }
        
        MFLAnalytics.record(event: .buttonTap(name: "Mood Icon Tapped - \(safeEmotion.name)", value: nil))
        didTap(emotion: safeEmotion)
    }
}

//MARK: - Helper
fileprivate extension HomeEmotionsView {
    
    func view(for emotion: Emotion) -> UIView {
        switch emotion {
        case .happy: return happyView
        case .neutral: return neutralView
        case .sad: return sadView
        }
    }
    
    func didTap(emotion: Emotion) {
        delegate?.homeEmotionsView(self, didSelect: emotion)
    }
    
    
    func hideAllViews() {
        allViews.forEach { $0.alpha = 0.0 }
    }
    
    func setAllViews(enabled: Bool) {
        allViews.forEach { $0.isUserInteractionEnabled = enabled }
    }
    
    func showAllViews(exept emotion: Emotion) {
        allViews.forEach {
            if !($0 === self.view(for: emotion)) {
                $0.alpha = 1.0
            }
        }
    }
    
    func getCenter() -> CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }
    
    func positionPlaceholder(with emotion: Emotion) {
        animatedPlaceholder.frame.size = multiplier * view(for: emotion).frame.size
        animatedPlaceholder.center = getCenter()
    }
    
    func positionMessageLabel() {
        let size = messageLabel.sizeThatFits(CGSize(width: self.width - (messageLabelPadding * 2), height: CGFloat.infinity))
        let y = animatedPlaceholder.frame.maxY + messageLabelTopSpacing
        let x = (width - size.width) / 2
        messageLabel.frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
}

fileprivate extension Emotion {
  
    var image : UIImage {
        switch self {
        case .happy: return UIImage(named: "home_emotion_happy", bundle: .mood)!
        case .neutral: return UIImage(named: "home_emotion_neutral", bundle: .mood)!
        case .sad: return UIImage(named: "home_emotion_sad", bundle: .mood)!
        }
    }
    
    var name : String {
        switch self {
        case .happy: return "Happy"
        case .neutral: return "Neutral"
        case .sad: return "Sad"
        }
    }
}





















