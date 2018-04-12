//
//  EmotionNoteNeutralViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class EmotionNoteNeutralViewController: EmotionNoteBaseChildViewController {
    
    fileprivate let speeds : [CGFloat] = [5.0, 10.0]
    
    fileprivate var shouldAnimate = false
    
    @IBOutlet fileprivate weak var emotionView_private: AnimatedEmotionView!
    
    @IBOutlet weak var element_0 : UIImageView!
    @IBOutlet weak var element_1 : UIImageView!
    
    @IBOutlet weak var element_0_initialConstraint : NSLayoutConstraint!
    @IBOutlet weak var element_1_initialConstraint : NSLayoutConstraint!
    
    fileprivate lazy var elements : [UIView] = {
        return [self.element_0, self.element_1]
    }()
    
    fileprivate lazy var initialConstraints : [NSLayoutConstraint] = {
        return [self.element_0_initialConstraint, self.element_1_initialConstraint]
    }()
    
    fileprivate lazy var endConstraints : [NSLayoutConstraint] = {
        var constraints = [NSLayoutConstraint]()
        for element in self.elements {
            let constraint = element.trailingAnchor.constraint(equalTo: self.view.leadingAnchor)
            constraints.append(constraint)
        }
        return constraints
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        emotionView = emotionView_private
        emotionView.emotion = .neutral
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startAnimations()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        elements.forEach { $0.layer.removeAllAnimations() }
        
        endConstraints.deactivate()
        initialConstraints.activate()
        
        view.layoutIfNeeded()
    }
    
    func startAnimations() {
        
        for i in 0..<elements.count {
        
            UIView.animate(withDuration: time(for: i),
                           delay: 0.0,
                           options: .curveLinear,
                           animations: {
                            self.initialConstraints[i].isActive = false
                            self.endConstraints[i].isActive = true
                            self.view.layoutIfNeeded()
            }) { finished in
                if finished { self.animate(i) }
            }
        }
    }
    
    fileprivate func animate(_ element: Int) {
        
        elements[element].frame.origin.x = self.view.width
        view.setNeedsLayout()
        
        UIView.animate(withDuration: time(for: element),
                       delay: 0.0,
                       options: .curveLinear,
                       animations: {
                        self.view.layoutIfNeeded()
        }) { finished in
            if finished { self.animate(element) }
        }
        
    }
    
    fileprivate func time(for element: Int) -> TimeInterval {
        return TimeInterval(distance(for: element) / speeds[element])
    }
    
    fileprivate func distance(for element: Int) -> CGFloat {
        return elements[element].width + elements[element].x
    }
}
