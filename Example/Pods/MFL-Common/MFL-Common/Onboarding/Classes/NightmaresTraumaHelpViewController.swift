//
//  SuicidalHelpViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import MFL_Common

class NightmaresTraumaHelpViewController: MFLViewController {

    var presenter : NightmaresTraumaHelpPresenter!
    
    @IBOutlet weak var counsellorAppContainerView : UIView!
    @IBOutlet weak var counsellorAppIconView : UIView!
    fileprivate var counsellorAppGradientLayer : CAGradientLayer?
    fileprivate var appIconGradinetLayer : CAGradientLayer?
    
    var style: Style!
    
    fileprivate lazy var cancelBarButton : UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel,
                               target: self,
                               action: #selector(NightmaresTraumaHelpViewController.cancelTapped))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarStyle = .default
        
        navigationItem.leftBarButtonItem = cancelBarButton
        
        setUpGradientLayers()
        setUpShadow()
    }
    
    @objc func cancelTapped(_ sender: Any) {
        presenter.userWantsToCancel()
    }
    
    func setUpGradientLayers() {
        counsellorAppGradientLayer = CAGradientLayer()
        counsellorAppGradientLayer?.colors = [UIColor.mfl_silverTwo, .white].map { $0.cgColor }
        counsellorAppGradientLayer?.frame = counsellorAppContainerView.bounds
        counsellorAppContainerView.layer.insertSublayer(counsellorAppGradientLayer!, at: 0)
        
        appIconGradinetLayer = CAGradientLayer()
        appIconGradinetLayer?.colors = [UIColor.mfl_green, .mfl_pea].map { $0.cgColor }
        appIconGradinetLayer?.frame = counsellorAppIconView.bounds
        counsellorAppIconView.layer.insertSublayer(appIconGradinetLayer!, at: 0)
    }
    
    func setUpShadow() {
        counsellorAppIconView.layer.shadowColor = UIColor.mfl_greyishBrown.cgColor
        counsellorAppIconView.layer.shadowOffset = CGSize(width: 3, height: 5)
        counsellorAppIconView.layer.shadowOpacity = 0.35
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        counsellorAppGradientLayer?.frame = counsellorAppContainerView.bounds
        appIconGradinetLayer?.frame = counsellorAppIconView.bounds
        appIconGradinetLayer?.cornerRadius = counsellorAppIconView.layer.cornerRadius
    }
    
    @IBAction func counsellingTapped(_ sender: Any) {
        presenter.userWantsToViewCounsellingApp()
    }
    
}

extension UIColor {
    static var mfl_silverTwo : UIColor { return #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1) }
}



