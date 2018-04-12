//
//  EmotionNoteBaseChildViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 03/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class EmotionNoteBaseChildViewController: UIViewController {

    fileprivate var emotionTimer : Timer?
    fileprivate let emotionAnimationWait = TimeInterval(10)
    var emotionView: AnimatedEmotionView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        stopTimer()
        startTimer()
    }

    fileprivate func startTimer() {
        
        if let timer = emotionTimer, timer.isValid { return }
        
        emotionTimer = Timer.scheduledTimer(withTimeInterval: emotionAnimationWait,
                                            repeats: true) { [weak self] _ in
                                                self?.emotionView.animate()
        }
        
        emotionTimer?.fire()
    }
    
    fileprivate func stopTimer() {
        emotionTimer?.invalidate()
        emotionTimer = nil
    }

}
