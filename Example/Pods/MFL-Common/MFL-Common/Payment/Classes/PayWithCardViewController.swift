//
//  PayWithCardViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 01/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import Stripe
import UnderKeyboard
import PKHUD

class PayWithCardViewController: MFLViewController {
    
    var presenter : PayWithCardPresenter!
    var style : Style!
    
    private lazy var keyboardObserver: UnderKeyboardObserver = {
        let observer = UnderKeyboardObserver()
        
        observer.animateKeyboard = { [unowned self] height in
            if height > 0 {
                let distance = self.view.frame.height - self.scrollView.frame.maxY
                
                self.keyboardConstraint.constant += (height - distance)
            } else {
                self.keyboardConstraint.constant = self.keyboardConstraintDefault
            }
            
            self.view.layoutIfNeeded()
        }
        
        return observer
    }()
    
    fileprivate let keyboardConstraintDefault = CGFloat(8.0)
    
    @IBOutlet weak var keyboardConstraint : NSLayoutConstraint!
    @IBOutlet weak var finishPaymentButton: RoundedButton!
    
    /** This is just a placeholder and should dissapear when the user select it*/
    @IBOutlet weak var cardDetailsPlaceholderTextFiled: MFLTextFieldView!
    
    @IBOutlet weak var cardBackgroundView: UIView!
    fileprivate var cardBackgroundGradientLayer : CAGradientLayer?
    @IBOutlet weak var cardView: CardDetailsView!
    @IBOutlet weak var cardDetailsTextFieldContainer: UIView!
    @IBOutlet weak var addressTextField: MFLTextFieldView!
    @IBOutlet weak var postCodeTextField: MFLTextFieldView!
    
    fileprivate var cardDetailsTextField : STPPaymentCardTextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate var scrollViewShouldScroll = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardObserver.start()
        setUpCardDetailsTextField()
        addOtherTextFieldsInputAccessory()
        
        cardDetailsPlaceholderTextFiled.isUserInteractionEnabled = false
        cardDetailsPlaceholderTextFiled.textField.isHidden = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCardDetailsContainer))
        cardDetailsTextFieldContainer.addGestureRecognizer(gesture)
    
        addressTextField.delegate = self
        postCodeTextField.delegate = self
        
        scrollView.delegate = self
        
        finishPaymentButton.setTitle(presenter.submitText, for: .normal)
        
        cardView.isUserInteractionEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        view.addGestureRecognizer(tapGesture)
        
        applyStyle()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let navController = navigationController, !navController.viewControllers.contains(self) {
            // Back tapped
            MFLAnalytics.record(event: .buttonTap(name: "Cancel Payment Tapped", value: nil))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cardBackgroundGradientLayer?.frame = cardBackgroundView.bounds
    }
    
    func applyStyle() {
        cardDetailsPlaceholderTextFiled.placeholderDefaultColor = style.primary
        cardDetailsPlaceholderTextFiled.separatorSuccessColor = style.primary
        cardDetailsTextField.textColor = style.textColor1
        
        addressTextField.placeholderDefaultColor = style.primary
        addressTextField.separatorSuccessColor = style.primary
        addressTextField.textColor = style.textColor1
        
        postCodeTextField.placeholderDefaultColor = style.primary
        postCodeTextField.separatorSuccessColor = style.primary
        postCodeTextField.textColor = style.textColor1
        
        
        finishPaymentButton.backgroundColor = style.primary
        finishPaymentButton.setTitleColor(style.textColor4, for: .normal)
        
        cardBackgroundGradientLayer?.removeFromSuperlayer()
        cardBackgroundGradientLayer = CAGradientLayer()
        cardBackgroundGradientLayer?.colors = style.gradient.map { $0.cgColor }
        cardBackgroundGradientLayer?.startPoint = CGPoint(x: 0, y: 0)
        cardBackgroundGradientLayer?.endPoint = CGPoint(x: 1, y: 1)
        cardBackgroundGradientLayer?.frame = cardBackgroundView.bounds
        cardBackgroundView.layer.insertSublayer(cardBackgroundGradientLayer!, at: 0)
    }
    
    deinit {
        keyboardObserver.stop()
    }
        
    func didTapCardDetailsContainer() {
        
        if cardDetailsTextField.isFirstResponder { return }
        animateCardDetailsPlaceholder(toEditable: true)
    }
    
    func setUpCardDetailsTextField() {
        
        cardDetailsTextFieldContainer.backgroundColor = UIColor.clear
        
        cardDetailsTextField = STPPaymentCardTextField()
        cardDetailsTextField.alpha = 0.0
        cardDetailsTextField.translatesAutoresizingMaskIntoConstraints = false
        cardDetailsTextField.borderColor = UIColor.clear
        cardDetailsTextField.font = UIFont.systemFont(ofSize: 17.0)
        
        
        cardDetailsTextFieldContainer.addSubview(cardDetailsTextField)
        
        let views: [String : Any] = ["textField" : cardDetailsTextField]
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[textField]|", options: [], metrics: nil, views: views) +
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(-16)-[textField]-(16)-|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraints)
        
        cardDetailsTextField.delegate = self
        
        addCardDetailsInputAccessory()
    }
    
    func addCardDetailsInputAccessory() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = style.primary
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(_:)))
        
        let backBarButtonItem = UIBarButtonItem(customView: inputButton(isNext: false))
        let nextBarButtonItem = UIBarButtonItem(customView: inputButton(isNext: true) {
            [weak self] in _ = self?.addressTextField.becomeFirstResponder()
        })
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([backBarButtonItem, nextBarButtonItem, spaceButton, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        cardDetailsTextField.inputAccessoryView = toolBar
    }
    
    private func inputButton(isNext: Bool, action: (() -> Void)? = nil) -> UIButton {
        let button = MFLButton(action: action)
        
        let nextImage = UIImage.template(named: "arrowDown", in: .common)
        let prevImage = UIImage.template(named: "arrowUp", in: .common)
        
        button.setBackgroundImage( isNext ? nextImage : prevImage, for: .normal)
        button.sizeToFit()
        button.isUserInteractionEnabled = isNext
        button.tintColor = isNext ? style.primary : style.primary.withAlphaComponent(0.4)
        
        return button
    }
    
    @objc fileprivate func doneTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    fileprivate func addOtherTextFieldsInputAccessory() {
        addressTextField.textField.addToolBar(
            backAction: { [weak self] in
                self?.animateCardDetailsPlaceholder(toEditable: true)
            },
            nextAction: { [weak self] in _ = self?.postCodeTextField.becomeFirstResponder() },
            style: style
            )
        
        postCodeTextField.textField.addToolBar(
            backAction: { [weak self] in _ = self?.addressTextField.becomeFirstResponder() },
            style: style
        )
    }
    
    fileprivate func animateCardDetailsPlaceholder(toEditable: Bool) {
    
        cardDetailsPlaceholderTextFiled.setPlaceholder(toSmall: toEditable, animated: true) { [unowned self] in
            if toEditable { self.cardDetailsTextField.becomeFirstResponder() }
            UIView.animate(withDuration: self.cardDetailsPlaceholderTextFiled.animationsDuration,
                           animations: {
                            self.cardDetailsTextField.alpha = toEditable ? 1.0 : 0.0
                            
            }, completion: nil)
        }
    }
    
    @IBAction func continueTapped(_ sender: AnyObject) {
        
        view.endEditing(false)
        
        validateCardDetails()
        
        do {
            try presenter.userWantsToFinishPaymentWith(CardDetails(cardDetailsTextField.cardParams,
                                                                   address: addressTextField.text,
                                                                   postCode: postCodeTextField.text))
        } catch let error {
            handle(error: error)
        }
    }
    
    @objc fileprivate func didTapView(_ sender: Any) {
        view.endEditing(true)
    }
}

extension CardDetails {
    init(_ cardParams: STPCardParams, address: String? = nil, postCode: String? = nil) {
        number = cardParams.number
        cvc = cardParams.cvc
        expirationMonth = Int(cardParams.expMonth)
        expirationYear = Int(cardParams.expYear)
        self.address = address ?? ""
        self.postCode = postCode ?? ""
    }
}

extension PayWithCardViewController : PayWithCardPresenterDelegate {
    
    func payWithCardPresenterDidStartPaying(_ sender: PayWithCardPresenter) {
        HUD.show(.progress)
    }
    
    func payWithCardPresenter(_ sender: PayWithCardPresenter, didFinishPayingWith error: Error?) {
        HUD.hide()
        
        if let error = error {
            showAlert(for: error)
        }
    }
    
    func payWithCardPresenter(_ sender: PayWithCardPresenter, wantsToShow alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

extension PayWithCardViewController : STPPaymentCardTextFieldDelegate {
    
    // Begin editing
    func paymentCardTextFieldDidBeginEditingNumber(_ textField: STPPaymentCardTextField) {
        lockScrollOnTop()
        cardView.selectedState = .number
    }
    
    func paymentCardTextFieldDidBeginEditingExpiration(_ textField: STPPaymentCardTextField) {
        lockScrollOnTop()
        cardView.selectedState = .expDate
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        lockScrollOnTop()
        cardView.selectedState = .cvc
    }
    
    // End editing
    func paymentCardTextFieldDidEndEditingNumber(_ textField: STPPaymentCardTextField) {
        handleCardDetailsDismiss()
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        handleCardDetailsDismiss()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        handleCardDetailsDismiss()
    }
    
    fileprivate func lockScrollOnTop() {
        scrollView.scrollRectToVisible(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollViewShouldScroll = false
        }
    }
    
    fileprivate func handleCardDetailsDismiss() {
        
        scrollViewShouldScroll = true
        
        if !cardDetailsTextField.hasText {
            animateCardDetailsPlaceholder(toEditable: false)
            cardDetailsPlaceholderTextFiled.resetToDefaultState()
        }
    }
}

extension PayWithCardViewController : MFLTextFieldViewDelegate {
    
    func textFieldViewEditingDidBegin(_ sender: MFLTextFieldView) {
        validateCardDetails()
    }
    
    func textFieldViewEditingDidEnd(_ sender: MFLTextFieldView) {
        if mfl_nilOrEmpty(sender.text) {
            sender.resetToDefaultState()
            return
        }
        
        if sender === addressTextField {
            addressTextField.error = presenter.isValid(address: addressTextField.text)
            return
        }
        
        if sender === postCodeTextField {
            postCodeTextField.error = presenter.isValid(postCode: postCodeTextField.text)
            return
        }
    }
    
    func textFieldViewEditingChanged(_ sender: MFLTextFieldView) { /* Empty */ }
    func textFieldViewEditingDidEndOnExit(_ sender: MFLTextFieldView) { /* Empty */ }
}

//MARK: - UIScrollViewDelegate
extension PayWithCardViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scrollViewShouldScroll {
            scrollView.contentOffset.y = 0.0
        }
    }
    
}

//MARK: - Helper
extension PayWithCardViewController {
    
    fileprivate func handle(error: Error) {
        
        if let error = error as? PayWithCardError {
            error.errors.forEach {
                switch $0 {
                case .cardParams(let error): cardDetailsPlaceholderTextFiled.error = error
                case .address(let error): addressTextField.error = error
                case .postCode(let error): postCodeTextField.error = error
                }
            }
        } else {
            showAlert(for: error)
        }
    }
    
    fileprivate func validateCardDetails() {
        if cardDetailsTextField.hasText {
            if !cardDetailsTextField.isValid {
                cardDetailsPlaceholderTextFiled.error = NSLocalizedString("The card details you have entered are invalid", comment: "")
            } else {
                cardDetailsPlaceholderTextFiled.error = presenter.isValid(cardDetails: CardDetails(cardDetailsTextField.cardParams))
            }
        }
    }
}
