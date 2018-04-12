//
//  EmergencyContactViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 28/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import UnderKeyboard
import PKHUD
import PassKit

class EmergencyContactViewController: UIViewController {
    
    var presenter : EmergencyContactPresenter!
    var style : Style!
    
    private let keyboardConstraintDefault = CGFloat(8.0)
    
    fileprivate let infoTextColor = UIColor.mfl_greyishBrown
    
    @IBOutlet weak var phoneTextField: MFLTextFieldView!
    @IBOutlet weak var firstnameTextField: MFLTextFieldView!
    @IBOutlet weak var lastnameTextField: MFLTextFieldView!
    @IBOutlet weak var relationshipTextField: MFLTextFieldView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    weak var applePayButton: PKPaymentButton!
    @IBOutlet weak var applePayView: UIView!
    @IBOutlet weak var payWithCardButton: RoundedButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTextFields()
        keyboardObserver.start()
    
        infoTextLabel.text = presenter.infoTitle
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        view.addGestureRecognizer(tapGesture)
        
        setUpApplePayButton()
        applyStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applePayView.isHidden = !presenter.isDeviceSupportingApplePay
        
        if presenter.hasUserCardSaved { payWithCardButton.setTitle(NSLocalizedString("Buy With Saved Card", comment: ""), for: .normal) }
        else { payWithCardButton.setTitle(NSLocalizedString("Buy With Card", comment: ""), for: .normal) }
    }
    
    private func setUpApplePayButton() {
        guard presenter.isDeviceSupportingApplePay else { return }
        
        let applePayButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
        
        applePayButton.translatesAutoresizingMaskIntoConstraints = false
        applePayButton.addTarget(self,
                                 action: #selector(EmergencyContactViewController.didTapApplePay(_:)),
                                 for: .touchUpInside)
        
        applePayView.addSubview(applePayButton)
        
        applePayButton.topAnchor.constraint(equalTo: applePayView.topAnchor).isActive = true
        applePayButton.bottomAnchor.constraint(equalTo: applePayView.bottomAnchor).isActive = true
        applePayButton.centerXAnchor.constraint(equalTo: applePayView.centerXAnchor).isActive = true
        applePayButton.widthAnchor.constraint(equalTo: payWithCardButton.widthAnchor).isActive = true
        applePayButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.applePayButton = applePayButton
    }
    
    func applyStyle() {
        titleLabel.textColor = style.textColor1
        infoTitleLabel.textColor = style.textColor2
        infoTextLabel.attributedText = presenter.infoText.attributedString(style: .tinyText,
                                                                           color: style.textColor2,
                                                                           alignment: .center)
        payWithCardButton.backgroundColor = style.primary
        
        phoneTextField.set(style)
        firstnameTextField.set(style)
        lastnameTextField.set(style)
        relationshipTextField.set(style)
    }
    
    func setUpTextFields() {
        
        phoneTextField.text = presenter.ice?.phoneNumber
        phoneTextField.delegate = self
        phoneTextField.textField.keyboardType = .phonePad
        phoneTextField.textField.addToolBar(nextAction: { [weak self] in _ = self?.firstnameTextField.becomeFirstResponder() },
                                            style: style)
        
        firstnameTextField.text = presenter.ice?.firstName
        firstnameTextField.delegate = self
        firstnameTextField.textField.addToolBar(backAction: { [weak self] in _ = self?.phoneTextField.becomeFirstResponder() },
                                                nextAction: { [weak self] in _ = self?.lastnameTextField.becomeFirstResponder() },
                                                style: style)
        
        lastnameTextField.text = presenter.ice?.lastName
        lastnameTextField.delegate = self
        lastnameTextField.textField.addToolBar(backAction: { [weak self] in _ = self?.firstnameTextField.becomeFirstResponder() },
                                               nextAction: { [weak self] in _ = self?.relationshipTextField.becomeFirstResponder() },
                                               style: style)
        
        relationshipTextField.text = presenter.ice?.relationship
        relationshipTextField.delegate = self
        relationshipTextField.textField.addToolBar(backAction: { [weak self] in _ = self?.lastnameTextField.becomeFirstResponder() },
                                                   style: style)
    }
    
    
    deinit {
        keyboardObserver.stop()
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        submit(usingApplePay: false)
    }
    
    @objc func didTapApplePay(_ sender: Any) {
        submit(usingApplePay: true)
    }
    
    fileprivate func submit(usingApplePay: Bool) {
        
        view.endEditing(false)
        
        do {
            
            if usingApplePay {
                
                try presenter.submitEmergencyContactAndApplePay(phoneNumber: phoneTextField.text,
                                                                firstName: firstnameTextField.text,
                                                                lastName: lastnameTextField.text,
                                                                relationship: relationshipTextField.text,
                                                                viewController: self)
                
            } else {
                
                try presenter.submitEmergencyContactAndContinue(phoneNumber: phoneTextField.text,
                                                                firstName: firstnameTextField.text,
                                                                lastName: lastnameTextField.text,
                                                                relationship: relationshipTextField.text)
            }
            
            
            
        } catch  let error as EmergencyContactError {
            handle(error)
        } catch {}
    }
    
    @objc fileprivate func didTapView(_ sender: Any) {
        view.endEditing(true)
    }
}

extension  EmergencyContactViewController : EmergencyContactPresenterDelegate {
    func emergencyContactPresenterDidStartUpdate(_ sender: EmergencyContactPresenter) {
        HUD.show(.progress)
    }
    
    func emergencyContactPresenter(_ sender: EmergencyContactPresenter, didFinishUpdateWith error: Error?) {
        HUD.hide()
        
        if let error = error {
            showAlert(for: error)
        }
    }
    
    func emergencyContactPresenter(_ sender: EmergencyContactPresenter, wantsToPresent alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func emergencyContactPresenter(_ sender: EmergencyContactPresenter, wantsToPresent error: Error) {
        showAlert(for: error)
    }
}

extension EmergencyContactViewController : MFLTextFieldViewDelegate {
    
    func textFieldViewEditingDidBegin(_ sender: MFLTextFieldView) { /* Empty */ }
    func textFieldViewEditingChanged(_ sender: MFLTextFieldView) { /* Empty */ }
    func textFieldViewEditingDidEndOnExit(_ sender: MFLTextFieldView) { /* Empty */ }
    
    func textFieldViewEditingDidEnd(_ sender: MFLTextFieldView) {
        
        if sender === phoneTextField {
            phoneTextField.error = presenter.validate(phoneNumber: phoneTextField.text)
        }
            
        else if sender === firstnameTextField {
            firstnameTextField.error = presenter.validate(firstName: firstnameTextField.text)
        }
            
        else if sender === lastnameTextField {
            lastnameTextField.error = presenter.validate(firstName: lastnameTextField.text)
        }
            
        else if sender === relationshipTextField {
            relationshipTextField.error = presenter.validate(relationship: relationshipTextField.text)
        }
    }
}

//MARK: - Helper
extension EmergencyContactViewController {
    
    func handle(_ error: EmergencyContactError) {
        
        error.errors.forEach {
            switch $0 {
            case .phoneNumber(let message): phoneTextField.error = message
            case .firstName(let message): firstnameTextField.error = message
            case .lastName(let message): lastnameTextField.error = message
            case .relationship(let message): relationshipTextField.error = message
            }
        }
    }
}



