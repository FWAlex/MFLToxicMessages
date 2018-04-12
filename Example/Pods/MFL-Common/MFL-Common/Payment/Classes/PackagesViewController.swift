//
//  PackagesViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD
import PassKit

class PackagesViewController: MFLViewController {
    
    var presenter : PackagesPresenter!
    var style : Style!
    
    @IBOutlet weak var itemsView: UIView!
    @IBOutlet weak var packagesView: MultiplePackagesView!
    @IBOutlet weak var itemImageView1: UIImageView!
    @IBOutlet weak var itemImageView2: UIImageView!
    @IBOutlet weak var itemImageView3: UIImageView!
    @IBOutlet var itemLabels: [UILabel]!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cardButton: RoundedButton!
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var applePayView: UIView!
    private weak var applePayButton: PKPaymentButton?
    
    fileprivate let itemsTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium),
                                               lineHeight: 21)
    
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
        
        applePayView.isHidden = !presenter.isDeviceSupportingApplePay
        
        packagesView.showsHorizontalScrollIndicator = false
        packagesView.packagesDelegate = self
        infoTitleLabel.isHidden = true
        
        infoTextView.delegate = self
        
        itemImageView1.image = UIImage(named: "stages", bundle: MFLCommon.shared.appBundle)
        itemImageView2.image = UIImage(named: "messages", bundle: MFLCommon.shared.appBundle)
        itemImageView3.image = UIImage(named: "forum", bundle: MFLCommon.shared.appBundle)
        
        applyStyle()
        setUpApplePayButton()
        
        presenter.viewDidLoad()
    }
    
    func applyStyle() {
        packagesView.style = style
        itemsView.backgroundColor = style.secondary
        itemLabels.forEach { $0.attributedText = $0.attributedText?.string.attributedString(style: self.itemsTextStyle, color: self.style.textColor4) }
        priceLabel.textColor = style.textColor1
        cardButton.backgroundColor = style.primary
        infoTitleLabel.textColor = style.textColor2
        infoTextView.tintColor = style.primary
    }
    
    private func setUpApplePayButton() {
        guard presenter.isDeviceSupportingApplePay else { return }
        
        let applePayButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
        
        applePayButton.translatesAutoresizingMaskIntoConstraints = false
        applePayButton.addTarget(self,
                                  action: #selector(PackagesViewController.applePayTapped(_:)),
                                  for: .touchUpInside)
        
        applePayView.addSubview(applePayButton)
        
        applePayButton.topAnchor.constraint(equalTo: applePayView.topAnchor, constant: 16).isActive = true
        applePayButton.bottomAnchor.constraint(equalTo: applePayView.bottomAnchor).isActive = true
        applePayButton.centerXAnchor.constraint(equalTo: applePayView.centerXAnchor).isActive = true
        applePayButton.widthAnchor.constraint(equalTo: cardButton.widthAnchor).isActive = true
        applePayButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.applePayButton = applePayButton
    }
    
    @IBAction func payWithCardTapped(_ sender: Any) {
        presenter.userWantsToPayWithCard()
    }
    
    @objc func applePayTapped(_ sender: Any) {
        presenter.userWantsToApplePay(on: self)
    }
    
    func didTapClose(_ sender: Any) {
        MFLAnalytics.record(event: .thresholdPassed(name: "Left Packages Screen"))
        presenter.userWantsToClose()
    }
}

extension PackagesViewController : PackagesPresenterDelegate {
    
    func packagesPresenterDidStartFetch(_ sender: PackagesPresenter) {
        HUD.show(.progress)
    }
    
    func packagesPresenter(_ sender: PackagesPresenter, didUpdate packages: [PackageDisplay], error: Error?) {
        HUD.hide()
        packagesView.set(packages)
        view.layoutIfNeeded()
    }
    
    func packagesPresenter(_ sender: PackagesPresenter, wantsToUpdate price: String) {
        priceLabel.text = price
        let infoText = presenter.paymentInfoAttrString(with: style)
        infoTextView.attributedText = infoText
        infoTextView.isHidden = infoText == nil
        infoTitleLabel.isHidden = infoText == nil
    }
    
    func packagesPresenter(_ sender: PackagesPresenter, wantsToShow alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func packagesPresenter(_ sender: PackagesPresenter, wantsToShow error: Error) {
        showAlert(for: error)
    }
}

extension PackagesViewController : MultiplePackagesViewDelegate {
    
    func packagesView(_ sender: MultiplePackagesView, didSelectPackageAt index: Int) {
        presenter.userDidSelectPackage(at: index)
    }
}

extension PackagesViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        presenter.userDidSelect(URL)
        return false
    }
}


