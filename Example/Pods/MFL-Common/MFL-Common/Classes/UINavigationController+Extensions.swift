//
//  UINavigationController+Extensions.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 28/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    public func mfl_show(_ viewController: UIViewController, sender: Any, replaceTop: Bool = false) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            if replaceTop {
                var newViewControllers = self.viewControllers
                newViewControllers.remove(at: self.viewControllers.count - 2)
                self.viewControllers = newViewControllers
            }
        
        })
        show(viewController, sender: sender)
        CATransaction.commit()
    
    }
    
    func mfl_pop(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func mfl_pop(to index: Int, animated: Bool) -> UIViewController? {
        
        var viewCtrls = viewControllers
        
        guard viewCtrls.count > 1,
            index >= 0,
            index < viewCtrls.count - 1 else {
                return nil
        }
        
        if viewCtrls.count == index + 2 {
            return popViewController(animated: animated)
        }
        
        viewCtrls.removeSubrange((index + 1)...(viewCtrls.count - 2))
        viewControllers = viewCtrls
        return popViewController(animated: animated)
    }
    
    
    /**
     *  Pops to the first view controller found that can be cast to the type given as parameter
     */
    func mfl_pop<T>(to type: T.Type, animated: Bool) -> UIViewController? {
        guard let index = viewControllers.index(where: { $0 is T }) else { return nil }
        return mfl_pop(to: index, animated: animated)
    }
    
    func mfl_present(_ viewController: UIViewController, transitioningDelegate: UIViewControllerTransitioningDelegate? = nil, navigationBarClass: UINavigationBar.Type? = nil, completion: (() -> Void)? = nil) -> UINavigationController? {
        
        var viewControllerToPresent: UIViewController
        
        if let navigationBarClass = navigationBarClass {
            let navCtrl = UINavigationController(navigationBarClass: navigationBarClass, toolbarClass: nil)
            navCtrl.viewControllers = [viewController]
            viewControllerToPresent = navCtrl
        } else {
            viewControllerToPresent = viewController
        }
        
        if let transitioningDelegate = transitioningDelegate {
            viewControllerToPresent.modalPresentationStyle = .custom
            viewControllerToPresent.transitioningDelegate = transitioningDelegate
        }
        
        present(viewControllerToPresent, animated: true, completion: nil)
        
        return viewControllerToPresent as? UINavigationController
    }
    
}
