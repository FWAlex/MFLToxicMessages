//
//  BoltonsListViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD

class BoltonsListViewController: MFLViewController {
    
    var presenter : BoltonsListPresenter!
    var style : Style!
    
    @IBOutlet fileprivate weak var boltonsListView: BoltonsListView!
    @IBOutlet fileprivate weak var priceLabel: UILabel!
    
    @IBOutlet fileprivate weak var itemsView: UIView!
    @IBOutlet fileprivate weak var itemImageView1: UIImageView!
    @IBOutlet fileprivate weak var itemImageView2: UIImageView!
    @IBOutlet fileprivate weak var itemLabel1: UILabel!
    @IBOutlet fileprivate weak var itemLabel2: UILabel!
    
    fileprivate let itemsTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium),
                                               lineHeight: 21)
    fileprivate let secondaryTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold),
                                                   lineHeight: 18)
    
    
    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!
    
    @IBOutlet weak var continueButton: RoundedButton!
    
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
        
        statusBarStyle = .default
        navigationItem.leftBarButtonItem = closeBarButton
        boltonsListView.listDelegate = self
    
        itemImageView1.image = UIImage(named: "stopwatch", bundle: MFLCommon.shared.appBundle)
        itemImageView2.image = UIImage(named: "calendar", bundle: MFLCommon.shared.appBundle)
        
        applyStyle()
        presenter.viewDidLoad()
    }
    
    fileprivate func applyStyle() {
        boltonsListView.style = style
        
        itemsView.backgroundColor = style.secondary
        itemLabel1.attributedText = "Sessions are one hour long.".attributedString(style: itemsTextStyle, color: style.textColor4)
        itemLabel2.attributedText = "Message the team to schedule a session at a time that suits you.".attributedString(style: itemsTextStyle, color: style.textColor4)
        
        primaryTextLabel.textColor = style.textColor1
        priceLabel.textColor = style.textColor1
        continueButton.backgroundColor = style.primary
        
        secondaryTextLabel.attributedText = "We recommend a maximum of one counselling session per week.".attributedString(style: secondaryTextStyle,
                                                                                                                           color: style.textColor2,
                                                                                                                           alignment: .center)
    }
    
    @objc fileprivate func didTapClose(_ sender: Any) {
        presenter.userWantsToClose()
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        presenter.userWantsToContinue()
    }
}

extension BoltonsListViewController : BoltonsListPresenterDelegate {
    
    func boltonsListPresenterRequiresViewController(_ sender: BoltonsListPresenter) -> UIViewController {
        return self
    }
    
    func boltonsListPresenter(_ sender: BoltonsListPresenter, wantsToShow boltons: [BoltonDisplay]) {
        boltonsListView.set(boltons)
        view.layoutIfNeeded()
    }
    
    func boltonsListPresenter(_ sender: BoltonsListPresenter, wantsToShowPrice price: String) {
        priceLabel.text = price
    }
    
    func boltonsListPresenter(_ sender: BoltonsListPresenter, wantsToShowActivity inProgress: Bool) {
        if inProgress {
            HUD.show(.progress)
        } else {
            HUD.hide()
        }
    }
    
    func boltonsListPresenter(_ sender: BoltonsListPresenter, wantsToShow alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func boltonsListPresenter(_ sender: BoltonsListPresenter, wantsToShow error: Error) {
        showAlert(for: error)
    }
}

extension BoltonsListViewController : BoltonsListViewDelegate {
    
    func boltonsListView(_ sender: BoltonsListView, didSelectBoltonAt index: Int) {
        presenter.userSelectedBolton(at: index)
    }
}



