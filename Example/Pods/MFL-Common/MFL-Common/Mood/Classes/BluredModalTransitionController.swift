//
//  BluredModalTransitionController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 26/01/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class BluredModalTransitionController : NSObject {
    
    static let `default` = BluredModalTransitionController(withDuration: 0.3)
    
    fileprivate var duration: TimeInterval
    fileprivate var isPresenting: Bool = true
    
    fileprivate lazy var blurView : UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    
    init(withDuration duration: TimeInterval) {
        self.duration = duration
        
        super.init()
    }
    
    @objc(transitionDuration:) func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
}

extension BluredModalTransitionController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        self.isPresenting = false
        return self
    }
    
}

extension BluredModalTransitionController : UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let key : UITransitionContextViewControllerKey = self.isPresenting ? .to : .from
        
        guard let modalController = transitionContext.viewController(forKey: key) else {return }
        
        guard let modalView = modalController.view else {return}
        
        if self.isPresenting {
            
            containerView.addSubview(self.blurView)
            
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[blurView]|", options: [], metrics: nil, views: ["blurView" : blurView]).activate()
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[blurView]|", options: [], metrics: nil, views: ["blurView" : blurView]).activate()
        }
        
        containerView.addSubview(modalView)
        
        containerView.layoutIfNeeded()
        
        UIView.animate(withDuration: self.duration, delay: 0, options: .curveEaseIn, animations: {
            
            self.blurView.effect = self.isPresenting ? UIBlurEffect(style: .extraLight) : nil
            
        }) { (completed: Bool) in
            
            
            if !self.isPresenting {
                self.blurView.removeFromSuperview()
                
                modalView.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
        
    }
    
}

