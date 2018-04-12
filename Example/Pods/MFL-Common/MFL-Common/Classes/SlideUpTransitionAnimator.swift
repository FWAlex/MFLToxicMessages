//
//  SlideUpTransitionAnimator.swift
//  MFLHalsa
//
//  Created by Jonathan Flintham on 21/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class SlideUpTransitionController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let frame = UIEdgeInsetsInsetRect(super.frameOfPresentedViewInContainerView, UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0))
        
        return frame
    }
}

class SlideUpTransitionAnimator: NSObject {
    
    fileprivate var presentDuration: TimeInterval
    fileprivate var dismissDuration: TimeInterval
    fileprivate var isPresenting: Bool = true
    fileprivate var presentationController: SlideUpTransitionController?
    
    init(withPresentDuration presentDuration: TimeInterval = 0.5, dismissDuration: TimeInterval = 0.3) {
        self.presentDuration = presentDuration
        self.dismissDuration = dismissDuration
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? presentDuration : dismissDuration
    }
}

extension SlideUpTransitionAnimator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresenting = false
        return self
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        presentationController = SlideUpTransitionController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }
}

extension SlideUpTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentation(using: transitionContext)
        } else {
            animateDismissal(using: transitionContext)
        }
    }
    
    func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let viewController = transitionContext.viewController(forKey: .to) else { return }
        guard let view = viewController.view else { return }
        
        let finalFrame = transitionContext.finalFrame(for: viewController)
        view.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)

        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: view.bounds,
                                      byRoundingCorners: [.topLeft, .topRight],
                                      cornerRadii: CGSize(width: 4, height: 4)).cgPath
        view.layer.mask = maskLayer
        
        transitionContext.containerView.addSubview(view)
        
        UIView.animate(
            withDuration: presentDuration,
            delay: 0,
            usingSpringWithDamping: 0.9, initialSpringVelocity: 5.0,
            options: .curveEaseInOut,
            animations: {
                view.frame = finalFrame
        },
            completion: { completed in
                transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
        })
    }
    
    func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: .to)
        
        guard let viewController = transitionContext.viewController(forKey: .from) else { return }
        guard let view = viewController.view else { return }
        
        let initialFrame = transitionContext.initialFrame(for: viewController)
        
        view.frame = initialFrame
        
        transitionContext.containerView.addSubview(view)
        
        toVC?.beginAppearanceTransition(true, animated: true)
        
        UIView.animate(
            withDuration: dismissDuration,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                view.frame = initialFrame.offsetBy(dx: 0, dy: initialFrame.height)
        },
            completion: { completed in
                view.layer.mask = nil
                transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                toVC?.endAppearanceTransition()
        })
    }
}
