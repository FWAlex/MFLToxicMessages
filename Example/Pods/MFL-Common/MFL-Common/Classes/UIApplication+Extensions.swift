//
//  UIApplication+Extensions.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 06/10/2017.
//

import Foundation

public extension UIApplication {
    
    public func topViewController() -> UIViewController? {
        
        guard let window = self.keyWindow, var topViewController = window.rootViewController else { return nil }
        
        while topViewController.presentedViewController != nil {
            topViewController = topViewController.presentedViewController!
        }
        
        while topViewController is UITabBarController || topViewController is UINavigationController {
            
            if let tabBarController = topViewController as? UITabBarController, let viewControllers = tabBarController.viewControllers {
                topViewController = viewControllers[tabBarController.selectedIndex]
            }
            
            if let navCtrl = topViewController as? UINavigationController {
                if let lastViewCtrl = navCtrl.viewControllers.last {
                    topViewController = lastViewCtrl
                } else {
                    break
                }
            }
        }
        
        return topViewController
    }
    
    public var mainWindow : UIWindow? {
        return keyWindow
    }
}

