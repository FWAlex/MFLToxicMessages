//
//  ForumViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD

class ForumViewController: MFLViewController {
    
    @IBOutlet var webView : UIWebView!
    var style : Style!

    fileprivate lazy var refreshBarButton : UIBarButtonItem = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.setImage(UIImage(named: "refresh_white", bundle: .forum), for: .normal)
        button.addTarget(self, action: #selector(ForumViewController.didTapRefresh), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()
    
    var presenter : ForumPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfoView(style)
        webView.delegate = self
        if let request = presenter.request {
            webView.loadRequest(request)
        }
    }
    
    @objc func didTapRefresh(_ sender: Any) {
        if let request = presenter.request {
            webView.loadRequest(request)
        }
    }
}

extension ForumViewController : UIWebViewDelegate {

    func webViewDidStartLoad(_ webView: UIWebView) {
        HUD.show(.progress)
        navigationItem.rightBarButtonItem = nil
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.hide()
        navigationItem.rightBarButtonItem = nil
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        HUD.hide()
        navigationItem.rightBarButtonItem = refreshBarButton
    }
}

extension ForumViewController : ForumPresenterDelegate {
    
    func forumPresenter(_ sender: ForumPresenter,
                        wantsToShowInfo text: String?,
                        button: String?,
                        action: (() -> Void)?) {
        
        guard isViewLoaded else { return } // this is to prevent crash if infoView is not initialised while notification coming from QuestionirieTracker. Cause: InfoView is implemeted in parent class (MFLViewController).
        
        guard let text = text else {
            hideInfoView()
            return
        }
        
        setInfo(text: text, buttonTitle: button, action: action, image: nil, isDismissable: false)
        showInfoView()
    }
}

