//
//  MaterialTransitionAnimator.swift
//  MFL-Common
//
//  Created by Yevgeniy Prokoshev on 14/03/2018.
//

import Foundation

protocol MaterialTransitionInitialFrameProvider {
    var initialFrame: CGRect { get }
    var initialView: UIView { get }
}

class MaterialTransitionAnimator: NSObject {
    
    fileprivate var presentDuration: TimeInterval
    fileprivate var dismissDuration: TimeInterval
    fileprivate var isPresenting: Bool = true
    
    init(isPresenting: Bool, presentDuration: TimeInterval = 0.3, dismissDuration: TimeInterval = 0.3) {
        self.presentDuration = presentDuration
        self.dismissDuration = dismissDuration
        self.isPresenting = isPresenting
        super.init()
    }
}

extension MaterialTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentation(using: transitionContext)
        } else {
            animateDismissal(using: transitionContext)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? presentDuration : dismissDuration
    }
    
    func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let toView = toViewController.view else { return }
         let containerView = transitionContext.containerView
         var initialFrame: CGRect = .zero
         var initialView: UIView = UIView()
        
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        if let fromViewController = fromViewController as? MaterialTransitionInitialFrameProvider {
            initialView = fromViewController.initialView
            initialView.frame = fromViewController.initialFrame
        }
        
        containerView.addSubview(toView)
        containerView.addSubview(initialView)
        toView.alpha = 0
        
        UIView.animateKeyframes(withDuration: presentDuration, delay: 0, options:.calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7, animations: {
                initialView.frame = finalFrame
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 1.0, animations: {
                toView.alpha = 1.0
            })
            
        }, completion: { completed in
            initialView.removeFromSuperview()
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
