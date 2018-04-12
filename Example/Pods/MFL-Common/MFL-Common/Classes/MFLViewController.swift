//
//  MFLViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 16/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import ReachabilitySwift

fileprivate let infoViewAnimationDuration = TimeInterval(0.3)

public enum NetworkStatus: String {
    case notReachable = "Cellular"
    case reachableViaWiFi = "WiFi"
    case reachableViaWWAN = "No Connection"
}

@IBDesignable open class MFLViewController: UIViewController {
    
    open fileprivate(set) var isViewVisible = false
    
    @IBInspectable public var hidesNavigationBar = false
    public var statusBarStyle = UIStatusBarStyle.lightContent
    
    fileprivate var infoViewZeroHeightConstraint : NSLayoutConstraint?
    fileprivate var infoViewTopConstraint : NSLayoutConstraint?
    fileprivate var infoView : MFLInfoView!
    
    public var shouldUseGradientBackground = false { didSet { setUpGradient() } }
    fileprivate var gradientLayer : CAGradientLayer?
    open var gradientLayerColors = [UIColor.white, .black]
    open var gradientStartPoint = CGPoint(x: 0.5, y: 0.0)
    open var gradientEndPoint = CGPoint(x: 0.5, y: 1.0)
    
    var reachability = Reachability()!
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    func setInfo(text: String?, buttonTitle: String? = nil ,action: (() -> Void)?, image: UIImage?, isDismissable: Bool) {
        infoView.text = text
        infoView.buttonTitle = buttonTitle
        infoView.action = action
        infoView.image = image
        infoView.isDismissable = isDismissable
        
        infoView.layoutIfNeeded()
    }
    
    func setInfoView(topAnchor: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) {
        infoViewTopConstraint?.isActive = false
        infoViewTopConstraint = infoView.topAnchor.constraint(equalTo: topAnchor, constant: constant)
        infoViewTopConstraint?.isActive = true
    }
    
    func setInfoView(_ style: Style?) {
        infoView.style = style
    }
    
    func showInfoView() {
        
        if isInfoViewVisible { return }
        
        UIView.animate(withDuration: infoViewAnimationDuration) {
            self.infoViewZeroHeightConstraint?.isActive = false
            self.view.layoutIfNeeded()
        }
    }
    
    func hideInfoView() {
        
        if !isInfoViewVisible { return }
        
        UIView.animate(withDuration: infoViewAnimationDuration) {
            self.infoViewZeroHeightConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    open var isInfoViewVisible : Bool {
        return !(infoViewZeroHeightConstraint?.isActive ?? false)
    }
    
    
    open var shouldShowNoInternetView = true
    
    open var noInternetViewBackgroundColor = UIColor.mfl_lollipop
    
    open var noInternetViewText = NSLocalizedString("No internet connection. Some features might not work.", comment: "")
    open var noInternetViewTextColor = UIColor.white
    open var noInternetViewTextFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightSemibold)
    
    open var noInternetView : UIView!
    open var noInternetViewHeightConstraint : NSLayoutConstraint!
    open var isNoInternetViewVisisble : Bool {
        if noInternetView == nil { setUpNoInternetView() }
        return !noInternetViewHeightConstraint.isActive
    }
    
    func setUpNoInternetView() {
        if noInternetView != nil {
            noInternetView.removeFromSuperview()
            noInternetView = nil
        }
        
        noInternetView = UIView()
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.backgroundColor = self.noInternetViewBackgroundColor
        noInternetView.clipsToBounds = true
        
        view.addSubview(noInternetView)
        
        noInternetView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        noInternetView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        noInternetView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        noInternetViewHeightConstraint = noInternetView.heightAnchor.constraint(equalToConstant: 0.0)
        noInternetViewHeightConstraint.isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = noInternetViewTextColor
        label.font = noInternetViewTextFont
        label.text = noInternetViewText
        noInternetView.addSubview(label)
        
        let c = label.topAnchor.constraint(equalTo: noInternetView.topAnchor, constant: 16 + topLayoutGuide.length)
        c.priority = 999
        c.isActive = true
        label.leadingAnchor.constraint(equalTo: noInternetView.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: noInternetView.trailingAnchor, constant: -16).isActive = true
        label.bottomAnchor.constraint(equalTo: noInternetView.bottomAnchor, constant: -16).isActive = true
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        
        view.layoutIfNeeded()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if statusBarStyle == .lightContent {
            if navigationController?.navigationBar.barStyle == .default {
                navigationController?.navigationBar.barStyle = .black
            }
        } else {
            if navigationController?.navigationBar.barStyle == .black {
                navigationController?.navigationBar.barStyle = .default
            }
        }
        
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.setNavigationBarHidden(hidesNavigationBar, animated: true)
    }
    
    open func setNoInternetView(visible isVisible: Bool, animated: Bool) {
        if noInternetView == nil { setUpNoInternetView() }
        
        if isNoInternetViewVisisble == isVisible { return }
        
        if animated {
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.setNoInternetView(visible: isVisible)
                }
            }
        } else {
            setNoInternetView(visible: isVisible)
        }
    }
    
    open func setNoInternetView(visible isVisible: Bool) {
        if noInternetView == nil { setUpNoInternetView() }
        
        self.noInternetViewHeightConstraint.isActive = !isVisible
        self.view.layoutIfNeeded()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpInfoView()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isViewVisible = true
        
        if shouldShowNoInternetView {
            setNoInternetView(visible: !reachability.isReachable, animated: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkReachabilityDidChange), name: ReachabilityChangedNotification, object: nil)
        
        do {
            try reachability.startNotifier()
        } catch {
            print(error)
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        isViewVisible = false
        
        setNoInternetView(visible: false, animated: false)
        
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability.stopNotifier()
    }
    
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setUpGradient() {
        
        gradientLayer?.removeFromSuperlayer()
        
        guard shouldUseGradientBackground else { return }
        
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = gradientLayerColors.map { $0.cgColor }
        gradientLayer?.startPoint = self.gradientStartPoint
        gradientLayer?.endPoint = self.gradientEndPoint
        gradientLayer?.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    fileprivate func setUpInfoView() {
        infoView = MFLInfoView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.delegate = self
        self.view.addSubview(infoView)
        
        self.infoViewTopConstraint = infoView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor)
        self.infoViewTopConstraint?.isActive = true
        
        self.infoViewZeroHeightConstraint = NSLayoutConstraint(item: infoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        self.infoViewZeroHeightConstraint?.isActive = true
        
        NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view" : infoView]).activate()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let noInternetView = self.noInternetView {
            view.bringSubview(toFront: noInternetView)
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer?.frame = view.bounds
    }
    
    @objc fileprivate func networkReachabilityDidChange() {
        if self.shouldShowNoInternetView { self.setNoInternetView(visible: !reachability.isReachable, animated: true) }
        
        guard let networkStatus = NetworkStatus(rawValue: reachability.currentReachabilityStatus.description) else { return }
        reachabilityDidChange(status: networkStatus)
    }
    
    func reachabilityDidChange(status: NetworkStatus) {
        debugPrint("Overide to respond for reachability status change")
    }
}

extension MFLViewController: MFLInfoViewDelegate {
    
    func infoViewWantsToClose(_ sender: MFLInfoView) {
        self.hideInfoView()
    }
}


