//
//  DateOfBirthViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 07/12/2017.
//
//

import UIKit
import UnderKeyboard

class DateOfBirthViewController : MFLViewController {
    
    var presenter : DateOfBirthPresenter!
    var style : Style!
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var questionLabel: UILabel!
    @IBOutlet fileprivate weak var dobTextField : MFLTextFieldView!
    @IBOutlet fileprivate weak var genderTextField: MFLTextFieldView!
    @IBOutlet fileprivate weak var disclaimerTitleLabel: UILabel!
    @IBOutlet fileprivate weak var disclaimerLabel: UILabel!
    @IBOutlet fileprivate weak var nextButton: RoundedButton!
    @IBOutlet fileprivate weak var bottomConstraint : NSLayoutConstraint!
    
    fileprivate let questionTextStyle = TextStyle(font: .systemFont(ofSize: 28, weight: UIFontWeightMedium),
                                                  lineHeight: 36)
    fileprivate let disclaimerTitleTextStyle = TextStyle(font: .systemFont(ofSize: 13, weight: UIFontWeightBold),
                                                         lineHeight: 15)
    fileprivate let disclaimerTextStyle = TextStyle(font: .systemFont(ofSize: 13, weight: UIFontWeightSemibold),
                                                    lineHeight: 20)
    
    fileprivate lazy var keyboardObserver: UnderKeyboardObserver = {
        let observer = UnderKeyboardObserver()
        
        observer.animateKeyboard = { [unowned self] height in
            if height > 0 {
                self.bottomConstraint.constant = height
                self.view.layoutIfNeeded()
            } else {
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            
            self.view.layoutIfNeeded()
        }
        
        return observer
    }()
    
    fileprivate lazy var datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(didSelectDate(_:)), for: .valueChanged)
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        return datePicker
    }()
    
    fileprivate lazy var genderPicker : UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        return pickerView
    }()
    
    fileprivate let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesNavigationBar = true
        
        titleLabel.text = presenter.title.uppercased()
        
        keyboardObserver.start()
        
        dobTextField.textField.inputView = datePicker
        dobTextField.delegate = self
        dobTextField.textField.addToolBar(backAction: nil,
                                          nextAction: { _ = self.genderTextField.becomeFirstResponder() },
                                          style: style)
        
        genderTextField.textField.inputView = genderPicker
        genderTextField.delegate = self
        genderTextField.textField.addToolBar(backAction: { _ = self.dobTextField.becomeFirstResponder() },
                                             nextAction: nil,
                                             style: style)
        
        applyStyle()
    }
    
    deinit {
        keyboardObserver.stop()
    }
    
    func applyStyle() {
        titleLabel.textColor = style.textColor2
        questionLabel.attributedText = questionLabel.text?.attributedString(style: questionTextStyle,
                                                                            color: style.textColor1,
                                                                            alignment: .center)
        let disclaimerTitle = presenter.disclaimerTitle?.uppercased()
        disclaimerTitleLabel.attributedText = disclaimerTitle?.attributedString(style: disclaimerTitleTextStyle,
                                                                                color: style.textColor2,
                                                                                alignment: .center)
        disclaimerLabel.attributedText = presenter.disclaimer?.attributedString(style: disclaimerTextStyle,
                                                                               color: style.textColor3,
                                                                               alignment: .center)
        nextButton.backgroundColor = style.textColor3
        nextButton.setTitleColor(style.textColor4, for: .normal)
        
        dobTextField.placeholderDefaultColor = style.primary
        dobTextField.separatorSuccessColor = style.primary
        
        genderTextField.placeholderDefaultColor = style.primary
        genderTextField.separatorSuccessColor = style.primary
    }
    
    @objc private func didSelectDate(_ sender: UIDatePicker) {
        let date = sender.date
        dobTextField.text = dateFormatter.string(from: date)
        presenter.userSelected(date)
    }
    
    @IBAction private func nextTapped(_ sender: Any) {
        presenter.userWantsToContinue()
    }
}

extension DateOfBirthViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.genderCount
    }
}

extension DateOfBirthViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter.titleForGender(at: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = presenter.titleForGender(at: row)
        presenter.userSelectedGender(at: row)
    }
}

extension DateOfBirthViewController : MFLTextFieldViewDelegate {
    
    func textFieldViewEditingDidEnd(_ sender: MFLTextFieldView) {
        
        if sender == dobTextField {
            let date = datePicker.date
            dobTextField.text = dateFormatter.string(from: date)
            presenter.userSelected(date)
        } else {
            sender.text = presenter.titleForGender(at: genderPicker.selectedRow(inComponent: 0))
            presenter.userSelectedGender(at: genderPicker.selectedRow(inComponent: 0))
        }
    }
    
    func textFieldViewEditingChanged(_ sender: MFLTextFieldView) { /* Empty */ }
    func textFieldViewEditingDidEndOnExit(_ sender: MFLTextFieldView) { /* Empty */ }
    func textFieldViewEditingDidBegin(_ sender: MFLTextFieldView) { /* Empty */ }
}

extension DateOfBirthViewController : DateOfBirthPresenterDelegate {
    func dateOfBirthPresenter(_ sender: DateOfBirthPresenter, wantsToAllowContiune isContinueAllowed: Bool) {
        nextButton.isUserInteractionEnabled = isContinueAllowed
        nextButton.backgroundColor = isContinueAllowed ? style.primary : style.textColor3
    }
}

