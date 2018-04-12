//
//  EmotionNoteSadViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class EmotionNoteSadViewController: EmotionNoteBaseChildViewController {

    fileprivate let speeds : [CGFloat] = [0.5, 2, 4, 6, 9, 3]
    
    @IBOutlet fileprivate weak var emotionView_private: AnimatedEmotionView!
    
    // No outlet collection because we want to easily control the order
    @IBOutlet fileprivate weak var element_0 : UIImageView!
    @IBOutlet fileprivate weak var element_1 : UIImageView!
    @IBOutlet fileprivate weak var element_2 : UIImageView!
    @IBOutlet fileprivate weak var element_3 : UIImageView!
    @IBOutlet fileprivate weak var element_4 : UIImageView!
    @IBOutlet fileprivate weak var element_5 : UIImageView!
    
    @IBOutlet fileprivate weak var initialConstraint_0 : NSLayoutConstraint!
    @IBOutlet fileprivate weak var initialConstraint_1 : NSLayoutConstraint!
    @IBOutlet fileprivate weak var initialConstraint_2 : NSLayoutConstraint!
    @IBOutlet fileprivate weak var initialConstraint_3 : NSLayoutConstraint!
    @IBOutlet fileprivate weak var initialConstraint_4 : NSLayoutConstraint!
    @IBOutlet fileprivate weak var initialConstraint_5 : NSLayoutConstraint!
    
    fileprivate lazy var elements : [UIView] = { return [ self.element_0, self.element_1, self.element_2, self.element_3, self.element_4, self.element_5] }()
    fileprivate lazy var initialConstraints : [NSLayoutConstraint] = {
        return [self.initialConstraint_0, self.initialConstraint_1, self.initialConstraint_2, self.initialConstraint_3, self.initialConstraint_4, self.initialConstraint_5]
    }()
    
    fileprivate lazy var endConstraints : [NSLayoutConstraint] = {
        var constraints = [NSLayoutConstraint]()
        for element in self.elements {
            constraints.append(element.trailingAnchor.constraint(equalTo: self.view.leadingAnchor))
        }
        
        return constraints
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        emotionView = emotionView_private
        emotionView.emotion = .sad
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startAnimations()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        endConstraints.deactivate()
        initialConstraints.activate()
        
        elements.forEach { $0.layer.removeAllAnimations() }
        
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
