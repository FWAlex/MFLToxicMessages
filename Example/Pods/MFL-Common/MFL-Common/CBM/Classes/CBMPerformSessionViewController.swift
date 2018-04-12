//
//  CBMPerformSessionViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 13/03/2018.
//
//

import UIKit
import Lottie

private let focusAnimationViewHeight = CGFloat(120.0)
private let probeButtonsPadding = CGFloat(20.0)

private let e_probeButtonImageName = "probe_button_e"
private let f_probeButtonImageName = "probe_button_f"
private let e_probeButtonImageNameDisabled = "probe_button_e_disabled"
private let f_probeButtonImageNameDisabled = "probe_button_f_disabled"

private let messageTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold), lineHeight: 23)

class CBMPerformSessionViewController: MFLViewController {
    
    var interactor : CBMPerformSessionInteractor!
    var style : Style!
    
    fileprivate weak var focusAnimationView : LOTAnimationView!
    
    //MARK: - Outlets
    @IBOutlet weak var probeButtonE: UIButton!
    @IBOutlet weak var probeButtonF: UIButton!
    @IBOutlet weak var xConstraintProbeButtonE: NSLayoutConstraint!
    @IBOutlet weak var xConstraintProbeButtonF: NSLayoutConstraint!
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var probeOneImageView: UIImageView!
    @IBOutlet weak var probeTwoImageView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesNavigationBar = true
        applyStyle()
        
        createFocusAnimationView()
        view.bringSubview(toFront: probeButtonE)
        view.bringSubview(toFront: probeButtonF)
        view.bringSubview(toFront: messageView)
        setImages(hidden: true)
        setPorbeButtons(enabled: false)
        setMessageView(hidden: true)
        setProbeButtonsToInitialPosition()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateProbeButtonsToDefaultPosition{ [weak self] _ in
            self?.interactor.viewDidAppear()
        }
    }
    
    //MARK: - Actions
    @IBAction func didTapE(_ sender: Any) {
        interactor.userDidSelectProbe_E()
    }
    
    @IBAction func didTapF(_ sender: Any) {
        interactor.userDidSelectProbe_F()
    }
}

//MARK: - Helper
private extension CBMPerformSessionViewController {
    
    func applyStyle() {
        messageView.backgroundColor = style.primary.withAlphaComponent(0.05)
    }
    
    func createFocusAnimationView() {
        let animationView = LOTAnimationView(filePath: Bundle.cbm.path(forResource: "focus_animation", ofType: "json")!)
        animationView.contentMode = .scaleAspectFill
        view.addSubview(animationView)
        view.bringSubview(toFront: animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            animationView.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        } else {
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: focusAnimationViewHeight).isActive = true
        
        focusAnimationView = animationView
    }
    
    func setPorbeButtons(enabled isEmabled: Bool) {
        var image = UIImage(named: isEmabled ? e_probeButtonImageName : e_probeButtonImageNameDisabled, bundle: .cbm)
        probeButtonE.setBackgroundImage(image, for: .normal)
        probeButtonE.isUserInteractionEnabled = isEmabled
        
        image = UIImage(named: isEmabled ? f_probeButtonImageName : f_probeButtonImageNameDisabled, bundle: .cbm)
        probeButtonF.setBackgroundImage(image, for: .normal)
        probeButtonF.isUserInteractionEnabled = isEmabled
    }
    
    func setProbeButtonsToInitialPosition() {
        xConstraintProbeButtonE.constant = -probeButtonE.width
        xConstraintProbeButtonF.constant = -probeButtonF.width
    }
    
    func animateProbeButtonsToDefaultPosition(_ completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3,
                       delay: 0.01,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: .curveLinear,
                       animations: { [weak self] in
                        self?.xConstraintProbeButtonE.constant = probeButtonsPadding
                        self?.xConstraintProbeButtonF.constant = probeButtonsPadding
                        self?.view.layoutIfNeeded()
        },
                       completion: completion)
    }
    
    
    func playFocusAnimation(_ completion: @escaping (Bool) -> Void) {
        focusAnimationView.play(completion: completion)
    }
    
    func show(images: CBMPerformSessionImagesDisplay) {
        imageViewOne.image = images.imageOne
        imageViewTwo.image = images.imageTwo
        
        UIView.animate(withDuration: 0.3,
                       animations: { [weak self] in
                        self?.setImages(hidden: false)
            }, completion: { [weak self] _ in
                self?.interactor.userDidSeeImages()
        })
    }
    
    func show(probes images: CBMPerformSessionImagesDisplay) {
        probeOneImageView.image = images.imageOne
        probeTwoImageView.image = images.imageTwo
        
        UIView.animate(withDuration: 0.3,
                       animations: { [weak self] in
                        self?.setProbes(hidden: false)
            }, completion: { [weak self] _ in
                self?.interactor.userDidSeeProbes()
        })
    }
    
    func show(message: String) {
        messageLabel.attributedText = messageTextStyle.attributedString(with: message,
                                                                        color: style.textColor1,
                                                                        alignment: .center)
        
        UIView.animate(withDuration: 0.3,
                       animations: { [weak self] in
                        self?.setMessageView(hidden: false)
            }, completion: { [weak self] _ in
                self?.interactor.userDidSeeMessage()
        })
    }
    
    func setImages(hidden isHidden: Bool) {
        imageViewOne.alpha = isHidden ? 0.0 : 1.0
        imageViewTwo.alpha = isHidden ? 0.0 : 1.0
    }
    
    func setProbes(hidden isHidden: Bool) {
        probeOneImageView.alpha = isHidden ? 0.0 : 1.0
        probeTwoImageView.alpha = isHidden ? 0.0 : 1.0
    }
    
    func setMessageView(hidden isHidden: Bool) {
        messageView.alpha = isHidden ? 0.0 : 1.0
    }
}

//MARK: - CBMPerformSessionPresenterDelegate
extension CBMPerformSessionViewController : CBMPerformSessionPresenterDelegate {
    
    func performSessionPresenterWantsToPresentFocus(_ sender: CBMPerformSessionPresenter) {
        playFocusAnimation { [weak self] _ in
            self?.interactor.userDidFocus()
        }
    }
    
    func performSessionPresenter(_ sender: CBMPerformSessionPresenter, wantsToSetInputEnabled isEnabled: Bool) {
        setPorbeButtons(enabled: isEnabled)
    }
    
    func performSessionPresenter(_ sender: CBMPerformSessionPresenter, wantsToPresentImages images: CBMPerformSessionImagesDisplay) {
        show(images: images)
    }
    
    func performSessionPresenterWantsToHideImages(_ sender: CBMPerformSessionPresenter) {
        setImages(hidden: true)
    }
    
    func performSessionPresenter(_ sender: CBMPerformSessionPresenter, wantsToPresentProbes images: CBMPerformSessionImagesDisplay) {
        show(probes: images)
    }
    
    func performSessionPresenterWantsToHideProbes(_ sender: CBMPerformSessionPresenter) {
        setProbes(hidden: true)
    }
    
    func performSessionPresenter(_ sender: CBMPerformSessionPresenter, wantsToShowMessage message: String) {
        show(message: message)
    }
    
    func performSessionPresenterWantsToHideMessage(_ sender: CBMPerformSessionPresenter) {
        setMessageView(hidden: true)
    }
}

