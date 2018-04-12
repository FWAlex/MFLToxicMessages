//
//  AnimatedEmotionView.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class AnimatedEmotionView: UIView {

    fileprivate lazy var emotionImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AnimatedEmotionView.imageTapped(_:))))
        
        self.addSubview(imageView)

        // Size
        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.426, constant: 0.0).isActive = true
        
        // Position
        NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        
        return imageView
    }()
    
    var emotion : Emotion? {
        didSet {
            emotionImageView.image = emotion?.image
            emotionImageView.animationImages = emotion?.frames()
            emotionImageView.animationDuration = emotion?.animationDuration ?? 0.1
        }
    }
    
    func animate() {
        if emotionImageView.isAnimating { return }
        emotionImageView.animationRepeatCount = 1
        emotionImageView.startAnimating()
    }
    
    @objc fileprivate func imageTapped(_ sender: Any) {
        animate()
    }
}

fileprivate extension Emotion {
    
    func frames() -> [UIImage] {
        
        var images = [UIImage]()
        
        switch self {
        case .happy: for i in 0...13 { images.append(UIImage(named: "happy_frame_\(i)", bundle: .mood)!) }
        case .neutral: for i in 0...22 { images.append(UIImage(named: "neutral_frame_\(i)", bundle: .mood)!) }
        case .sad: for i in 0...15 { images.append(UIImage(named: "sad_frame_\(i)", bundle: .mood)!) }
        }
        
        return images
    }
    
    var animationDuration : TimeInterval {
        switch self  {
        case .happy: return 1
        case .neutral: return 1.5
        case .sad: return 1.5
        }
    }
    
    var image : UIImage {
        
        switch self {
        case .happy: return UIImage(named: "happy_frame_0", bundle: .mood)!
        case .neutral: return UIImage(named: "neutral_frame_0", bundle: .mood)!
        case .sad: return UIImage(named: "sad_frame_0", bundle: .mood)!
        }
    }
    
}
