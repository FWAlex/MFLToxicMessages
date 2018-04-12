//
//  EmotionNoteHappyViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class EmotionNoteHappyViewController: EmotionNoteBaseChildViewController {

    @IBOutlet fileprivate weak var emotionView_private: AnimatedEmotionView!
    @IBOutlet fileprivate weak var emementView_0: UIImageView!
    
    fileprivate let element_0_animTime = TimeInterval(50)
    
    fileprivate var isAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        emotionView = emotionView_private
        emotionView.emotion = .happy
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isAnimating {
            isAnimating = true
            animateElements()
        }
    }
    
    fileprivate func animateElements() {
        
        UIView.animate(withDuration: element_0_animTime,
                       delay: 0.0,
                       options: .curveLinear,
                       animations: {
                        self.emementView_0.transform = self.emementView_0.transform.rotated(by: .pi)
        }) { _ in
            self.animateElements()
        }
    }
    
    fileprivate func animateEmotion() {
        emotionView.animate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.animateEmotion()
        }
    }
}
