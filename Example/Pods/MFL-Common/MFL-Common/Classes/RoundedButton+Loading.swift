//
//  RoundedButton+Loading.swift
//  Pods
//
//  Created by Yevgeniy Prokoshev on 14/03/2018.
//

import Foundation


public extension RoundedButton {
    
    private static var ActivityTag = 9999
    
    public var isAnimating: Bool {
        get {
            return ((self.viewWithTag(RoundedButton.ActivityTag) as? UIActivityIndicatorView) != nil)
        }
    }
    
    private var activityView : UIActivityIndicatorView {
        get {
            let activityView = UIActivityIndicatorView()
            activityView.hidesWhenStopped = true
            activityView.tag = RoundedButton.ActivityTag
            activityView.color = self.tintColor
            return activityView
        }
    }
    
    public func startAnimating() {
        
        if let activityView = self.viewWithTag(RoundedButton.ActivityTag) as? UIActivityIndicatorView {
            activityView.startAnimating()
            self.bringSubview(toFront: activityView)
            showWithAnimation(view: activityView)
        } else {
            let newActivityView = activityView
            self.addSubview(newActivityView)
            newActivityView.startAnimating()
            showWithAnimation(view: newActivityView)
        }
      
        self.isEnabled = false
    }
    
    public func stopAnimating() {
     
        guard let activityView = self.viewWithTag(RoundedButton.ActivityTag) as? UIActivityIndicatorView else { return }
        activityView.stopAnimating()
        self.isEnabled = true
    }
    
    private func showWithAnimation(view: UIView) {
        view.sizeToFit()
        view.center = CGPoint(x: self.bounds.maxX + view.bounds.width, y: self.bounds.midY)
        view.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
            view.center = CGPoint(x: self.bounds.maxX - view.bounds.width, y: self.bounds.midY)
        }
    }
}
