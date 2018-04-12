//
//  CBMFinalScreenViewController.swift
//  Pods
//
//  Created by Yevgeniy Prokoshev on 19/03/2018.
//
//

import UIKit

class CBMFinalScreenViewController: MFLViewController {
    
    fileprivate let thanksMessage = "Thanks for completing this session. Remember that you should be completing three sessions per day.\n\nSee you soon for the next session."
    
    fileprivate let messageTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium), lineHeight: 24)
    
    var interactor : CBMFinalScreenInteractor!
    var style : Style!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var actionButtonCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var actionButton: RoundedButton! {
        didSet {
            actionButton.setTitle("Ok", for: .normal)
            actionButton.setTitleColor(.white, for: .normal)
            actionButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
            actionButton.backgroundColor = UIColor.init(r: 3, g: 122, b: 191)
            actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
            actionButton.tintColor = .white
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesNavigationBar = true
        actionButtonCenterConstraint.constant = -50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyStyle()
        self.actionButton.isEnabled = (reachability.currentReachabilityStatus != .notReachable)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        messageLabel.sizeToFit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        runActionButtonAnimation()
    }
    
    func applyStyle() {
        messageLabel.attributedText = messageTextStyle.attributedString(with: thanksMessage, color: style.textColor1, alignment: .center)
        titleLabel.textColor = style.textColor1
    }
    
    func runActionButtonAnimation() {
        actionButtonCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveLinear, animations: {[weak self] in
            guard let sself = self else { return }
            sself.view.layoutIfNeeded()
        })
    }

    @IBAction func actionHandler(_ sender: RoundedButton) {
        interactor.userWantsToFinishSession()
    }
    
    override func reachabilityDidChange(status: NetworkStatus) {
        DispatchQueue.main.async {
            self.actionButton.isEnabled = (status != .notReachable)
        }
    }
}


extension CBMFinalScreenViewController : CBMFinalScreenPresenterDelegate {
    func finlaScreenPresenter(_ presenter: CBMFinalScreenPresenter, wantsToPresentActivity inProgress: Bool) {
        self.actionButton.setTitle("Sending results", for: .disabled)
        self.actionButton.startAnimating()
    }
    
    func finalScreenPresenter(_ presenter: CBMFinalScreenPresenter, wantsToPresent error: Error) {
        showAlert(for: error)
        self.actionButton.setTitle(nil, for: .disabled)
        self.actionButton.stopAnimating()
    }
}
