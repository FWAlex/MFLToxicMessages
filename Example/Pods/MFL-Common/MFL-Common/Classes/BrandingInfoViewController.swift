//
//  BrandingInfoViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 14/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD

class BrandingInfoViewController: MFLViewController {
    
    var presenter : BrandingInfoPresenter!
    var style : Style!
    var isModal : Bool!
    
    @IBOutlet var webView : UIWebView!
    
    lazy var closeBarButton : UIBarButtonItem = {
       
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
        let image = UIImage.template(named: "close_white", in: .common)
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = self.style.primary
        button.sizeToFit()
        
        return UIBarButtonItem(customView: button)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.tintColor = style.primary
        if isModal { navigationItem.leftBarButtonItem = closeBarButton }
        statusBarStyle = .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let request = presenter.request {
            webView.loadRequest(request)
        }
    }
    
    open func didTapClose(_ sender: Any) {
        presenter.userWantsToClose()
    }
}

extension BrandingInfoViewController : BrandingInfoPresenterDelegate {
    
}

extension BrandingInfoViewController : UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        HUD.show(.progress)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.hide()
    }
    
}
