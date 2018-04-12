//
//  PasscodeViewController.swift
//  Passcode
//
//  Created by Yevgeniy Prokoshev on 27/03/2018.
//  Copyright © 2018 Future Workshops. All rights reserved.
//

import UIKit

public struct PasscodeData {

    enum InputType {
        case set
        case get
    }
    
    var inputType: InputType
    var numberOfDigits: Int
}

public struct PasscodeViewStyle {
    
    static let defaultStyle: PasscodeViewStyle = {
        let style = PasscodeViewStyle(titleColor: .white,
                                      titleFont: .systemFont(ofSize: 14),
                                      dialButtonsColor: .magenta,
                                      dialButtonsTextColor: .white,
                                      dialButtonsFont: .boldSystemFont(ofSize: 17),
                                      indicatorColor: .white,
                                      actionButtonFont: .systemFont(ofSize: 15),
                                      actionButtonTitleColor: .white)
        return style
    }()
    
    let titleColor: UIColor
    let titleFont: UIFont
    let dialButtonsColor: UIColor
    let dialButtonsTextColor: UIColor
    let dialButtonsFont: UIFont
    let indicatorColor: UIColor
    let actionButtonFont: UIFont
    let actionButtonTitleColor: UIColor
}

public protocol PasscodeViewDelegate: class {
    func userDidEnterPasscode(_ passcode: String, invalidInputBlock: (()->Void)?)
    func userDidTapActionButton(_ sender: UIButton)
}


public final class PasscodeViewController: UIViewController {

    private let enterPasscodeText = "Enter Passcode"
    private let reenterPasscodeText = "Re-Enter Passcode"
    
    private let actionButtonCancelText = "Cancel"
    private let actionButtonDeleteText = "Delete"
    private let actionButtonLogoutText = "Log Out"

    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var actionButton: UIButton! {
        didSet {
            updateActionButton()
        }
    }
    
    @IBOutlet weak private var inputDotsStackView: UIStackView! {
        didSet {
            inputDotsStackView.arrangedSubviews.forEach { (view) in
                view.layer.cornerRadius = view.frame.width/2
                view.layer.borderWidth = 1.0
                view.isHidden = true
            }
        }
    }
    
    @IBOutlet private var inputButtons: [UIButton]! {
        didSet {
            inputButtons.forEach { (button) in
                button.addTarget(self, action: #selector(didSelectDigit(_:)), for: .touchUpInside)
            }
            
            inputButtons.forEach { (button) in
                button.layer.cornerRadius = button.frame.width/2
            }
        }
    }
    
    private var inputAccumulator:[String] = []
    private var passcode: String?
    private var style: PasscodeViewStyle = .defaultStyle
    private var passCodeLength: Int = 4
    
    private var inputType: PasscodeData.InputType = .set
    
    public var backgroundView: UIView?
    public weak var delegate: PasscodeViewDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if let backgroundView = backgroundView {
            self.view.insertSubview(backgroundView, at: 0)
        }
        
        configureInputIndicator()
        applyStyle(style)
    }

    
    
    public override func viewWillLayoutSubviews() {
         super.viewWillLayoutSubviews()
        
        if let backgroundView = backgroundView {
            backgroundView.frame = view.bounds
        }
    }
    
    //MARK: Public
    public func configure(withData data: PasscodeData) {
        self.passCodeLength = min(6, data.numberOfDigits)
        self.inputType = data.inputType
    }
 
    public func configure(style: PasscodeViewStyle) {
        self.style = style
    }
    
    
    //MARK: Private
    
    private func applyStyle(_ style: PasscodeViewStyle) {
        
        self.titleLabel.font = style.titleFont
        self.titleLabel.textColor = style.titleColor
        self.actionButton.titleLabel?.font = style.actionButtonFont
        self.actionButton.tintColor = style.actionButtonTitleColor
        
        self.inputDotsStackView.subviews.forEach{
            $0.backgroundColor = .clear
            $0.layer.borderColor = style.indicatorColor.cgColor
        }
        
        self.inputButtons.forEach {
            $0.titleLabel?.font = style.dialButtonsFont
            $0.tintColor = style.dialButtonsTextColor
            $0.backgroundColor = style.dialButtonsColor
        }
    }

    private func configureInputIndicator() {
        inputDotsStackView.subviews.forEach{$0.isHidden = true}
        let viewsToShow = Array(inputDotsStackView.arrangedSubviews.prefix(passCodeLength))
        viewsToShow.forEach{$0.isHidden = false}
    }
    
    @IBAction func buttonDidTap(_ sender: UIButton) {
        if inputAccumulator.count > 0 {
            inputDot(atIndex: inputAccumulator.count - 1, setFill: false, animationCompletion: nil)
            inputAccumulator.removeLast()
        } else {
            delegate?.userDidTapActionButton(sender)
        }
        updateActionButton()
    }
    
    @objc func didSelectDigit(_ sender: UIButton) {
        
        if let digit = sender.titleLabel?.text {
            if (inputAccumulator.count < passCodeLength) {
                inputAccumulator.append(digit)
            }
            inputDot(atIndex: inputAccumulator.count - 1, setFill: true, animationCompletion: {
                self.checkInput()
                self.updateActionButton()
            })
        }
    }
    
    private func checkInput() {
        
        if inputAccumulator.count == passCodeLength {
            switch inputType {
            case .set:
                if let _ = passcode {
                    validateReeneteredPassword()
                } else {
                    reEnter()
                }
            case .get:
                let passcode = inputAccumulator.joined()
                delegate?.userDidEnterPasscode(passcode, invalidInputBlock: {[weak self] in
                    self?.shakeDotInputView()
                    self?.resetInput()
                })
            }
        }
    }
    
    private func updateActionButton() {
        
        UIView.transition(with: actionButton, duration: 0.2, options: .curveEaseIn, animations: {
            if self.inputAccumulator.count == 0 {
                if self.inputType == .get {
                    self.actionButton.setTitle(self.actionButtonLogoutText, for: .normal)
                } else {
                    self.actionButton.setTitle(self.actionButtonCancelText, for: .normal)
                }
            } else {
                self.actionButton.setTitle(self.actionButtonDeleteText, for: .normal)
            }
        }, completion: nil)
    }
    
    private func reEnter() {
        passcode = inputAccumulator.joined()
        titleLabel.text = reenterPasscodeText
        resetInput()
    }
    
    private func validateReeneteredPassword() {
        guard let passcode = passcode else { return }
        let reeneteredPasscode = inputAccumulator.joined()
        if (passcode == reeneteredPasscode) {
            delegate?.userDidEnterPasscode(passcode, invalidInputBlock: nil)
        } else {
            shakeDotInputView()
            resetInput()
        }
    }
    
    private func resetInput() {
        inputAccumulator = []
        inputDotsStackView.arrangedSubviews.forEach({$0.backgroundColor = .clear})
    }
    
    
    private func inputDot(atIndex index: Int, setFill: Bool, animationCompletion: (()->Void)?) {
        
        precondition(index <= inputDotsStackView.arrangedSubviews.count - 1)
        let filledDotView = inputDotsStackView.arrangedSubviews[index]
        UIView.transition(with: filledDotView, duration: 0.2, options: .curveEaseInOut, animations: {
            filledDotView.backgroundColor = setFill ? self.style.indicatorColor : .clear
        }, completion: { (finished) in
            animationCompletion?()
        })
    }
    
    private func shakeDotInputView() {
        inputDotsStackView.transform = CGAffineTransform(translationX: 12, y: 0)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 3.5, options: .curveLinear, animations: {
            self.inputDotsStackView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        resetInput()
    }
    
}
