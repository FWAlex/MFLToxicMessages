//
//  VideoChatViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 14/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD

class VideoChatViewController: MFLViewController {
    
    var presenter : VideoChatPresenter!
    
    @IBOutlet weak var subscriberView: UIView!
    @IBOutlet weak var publisherView: UIView!
    @IBOutlet weak var controlsStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var therapistImageView: RoundImageView!
    @IBOutlet weak var waitingLabel: UILabel!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    
    fileprivate let animationDuration = TimeInterval(0.3)
    
    @IBOutlet weak var controlsBottomConstraint: NSLayoutConstraint!
    fileprivate let controlsDefaultBottomSpace = CGFloat(24.0)
    fileprivate var isControlsHidden = false
    
    var foo : CGFloat {
        return bottomLayoutGuide.length
    }
    
    fileprivate lazy var cameraActiveImage : UIImage? = { return UIImage(named: "video_camera_active", bundle: .getMoreHelp) }()
    fileprivate lazy var cameraInactiveImage : UIImage? = { return UIImage(named: "video_camera_inactive", bundle: .getMoreHelp) }()
    fileprivate lazy var closeImage : UIImage? = { return UIImage(named: "video_close", bundle: .getMoreHelp) }()
    fileprivate lazy var micActiveImage : UIImage? = { return UIImage(named: "video_mic_active", bundle: .getMoreHelp) }()
    fileprivate lazy var micInactiveImage : UIImage? = { return UIImage(named: "video_mic_inactive", bundle: .getMoreHelp) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        titleLabel.text = presenter.title
        waitingLabel.text = presenter.waitingText
        therapistImageView.mfl_setImage(withUrlString: presenter.teamMemberImageUrlString)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSubscriberView(_:)))
        subscriberView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.toggleControls()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    @objc fileprivate func didTapSubscriberView(_ sender: Any) {
        toggleControls()
    }
    
    fileprivate func toggleControls() {
        
        controlsBottomConstraint.constant = isControlsHidden ? controlsDefaultBottomSpace : -controlsStackView.height
        isControlsHidden = !isControlsHidden
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func didTapCamera(_ sender: Any) {
        
        presenter.isCameraActive = !presenter.isCameraActive
        publisherView.isHidden = !presenter.isCameraActive
        cameraButton.setBackgroundImage(presenter.isCameraActive ? cameraActiveImage : cameraInactiveImage,
                                        for: .normal)
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        presenter.userWantsToClose()
    }
    
    @IBAction func didTapMic(_ sender: Any) {
        presenter.isMicActive = !presenter.isMicActive
        micButton.setBackgroundImage(presenter.isMicActive ? micActiveImage : micInactiveImage,
                                     for: .normal)
    }
    
}

extension VideoChatViewController : VideoChatPresenterDelegate {
    
    func presenterRequiresPublisherView(_ sender: VideoChatPresenter) -> UIView {
        return publisherView
    }
    
    func presenterRequiresSubscriberView(_ sender: VideoChatPresenter) -> UIView {
        return subscriberView
    }
    
    func videoChatPresenter(_ sender: VideoChatPresenter, wantsToShowActivity inProgress: Bool) {
        if inProgress {
            HUD.show(.progress)
        } else {
            HUD.hide()
        }
    }
    
    func videoChatPresenter(_ sender: VideoChatPresenter, wantsToShow alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func videoChatPresenter(_ sender: VideoChatPresenter, whatsToSetWaitingMessageVisible isVisible: Bool) {
        waitingLabel.isHidden = !isVisible
    }
    
    func videoChatPresenter(_ sender: VideoChatPresenter, whatsToSetTeamMemberImageVisible isVisible: Bool) {
        UIView.animate(withDuration: animationDuration) {
            self.therapistImageView.alpha = isVisible ? 1.0 : 0.0
        }
        
    }
    
    // --- Error ---
    func presenter(_ sender: VideoChatPresenter, errorOccurred error: Error) {
        showAlert(for: error)
    }
    
}


