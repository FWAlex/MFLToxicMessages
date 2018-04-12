//
//  CBMSessionInfoViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 08/03/2018.
//
//

import UIKit

class CBMSessionInfoViewController: MFLViewController {
    
    // MARK: Constants
    fileprivate let helpMessages = ["In this task, you will respond to target letters as quickly as possible. You should rest your thumbs above the buttons on the left and right of your screen.\n\nEach trial starts with a fixation point in the centre of the screen, which you should look at. Then a pair of images will briefly appear, on the top and bottom of the screen.",
                                    "After the images disappear, a target letter (E or F) will appear either at the top or the bottom of the screen. You should press the ‘E’ button if you see the ‘E’ or the ‘F’ button if you see the ‘F’. Try to respond as quickly and accurately as possible.\n\nAfter you have responded, the next trial will begin.\n\nThe task will take a few minutes to complete."]
    
    fileprivate let messageTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium), lineHeight: 24)
    
    fileprivate let clockImageView = UIImageView(image:UIImage(named: "timerIcon", bundle: .common))
    fileprivate let probeA_ImageView = UIImageView(image:UIImage(named: "eGraphic", bundle: .common))
    fileprivate let probeB_ImageView = UIImageView(image:UIImage(named: "fGraphic", bundle: .common))
    fileprivate var interactiveAnimator: UIViewPropertyAnimator?
    fileprivate var didLayout = false
    
    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.isPagingEnabled = true
            scrollView.delegate = self
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.backgroundColor = .clear
            scrollView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var iconsContainer: UIView! {
        didSet {
            iconsContainer.addSubview(clockImageView)
            iconsContainer.addSubview(probeA_ImageView)
            iconsContainer.addSubview(probeB_ImageView)
            let margin: CGFloat = 10.0

            let iconSize = CGSize(width: iconsContainer.frame.height - margin, height: iconsContainer.frame.height - margin)
            clockImageView.frame = CGRect(x: 0, y: 0, width:iconSize.width , height: iconSize.height)
            probeA_ImageView.frame = CGRect(x: 0, y: 0, width:iconSize.width , height: iconSize.height)
            probeB_ImageView.frame = CGRect(x: 0, y: 0, width:iconSize.width , height: iconSize.height)
            
            clockImageView.contentMode = .scaleAspectFit
            probeA_ImageView.contentMode = .scaleAspectFit
            probeB_ImageView.contentMode = .scaleAspectFit
            
        }
    }
    
    @IBOutlet weak var actionButtonTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var actionButtonContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.numberOfPages = helpMessages.count
            pageControl.pageIndicatorTintColor = style.secondary
            pageControl.currentPageIndicatorTintColor = .white
        }
    }
    
    var interactor : CBMSessionInfoInteractor!
    var style : Style!
    
    @IBOutlet weak var actionButton: RoundedButton! {
        didSet {
            actionButton.setTitle("Next", for: .normal)
            actionButton.setTitle("Loading", for: .disabled)
            actionButton.setTitleColor(style.primary, for: .normal)
            actionButton.setTitleColor(style.primary.withAlphaComponent(0.5), for: .disabled)
            actionButton.backgroundColor = .white
            actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
            actionButton.tintColor = UIColor(r: 3, g: 122, b: 191)
        }
    }

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
        shouldUseGradientBackground = true
        hidesNavigationBar = true
        setupScrollView()
        actionButtonTopSpaceConstraint.constant = -50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.viewDidAppear()
        runActionButtonAnimation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutScrollView()
        setupInteractiveAnimator()
    }
    
    func setupInteractiveAnimator() {
        interactiveAnimator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.5)
        
         if pageControl.currentPage == 0 {
            self.layoutIcons()
            self.interactiveAnimator?.addAnimations({[weak self] in
                self?.secondPageLayout()
            })
         } else {
            self.secondPageLayout()
            self.interactiveAnimator?.addAnimations({[weak self] in
                self?.layoutIcons()
            })
            self.interactiveAnimator?.isReversed = true
        }
    }
    
    @IBAction func actionButtonDidTap(_ sender: UIButton) {
        
        if (pageControl.currentPage == 0) {
            runFullAnimation()
        } else {
            interactor.userWantsToStartTrial()
        }
    }
}

extension CBMSessionInfoViewController : CBMSessionInfoPresenterDelegate {
    func sessionPresenter(_ presenter: CBMSessionInfoPresenter, wantsToPresentActivity inProgress: Bool) {
        if inProgress {
            scrollView.isUserInteractionEnabled = false
            actionButton.startAnimating()
        } else {
            actionButton.stopAnimating()
            scrollView.isUserInteractionEnabled = true
        }
    }
    
    func sessionPresenter(_ presenter: CBMSessionInfoPresenter, wantsToPresent alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}


private extension CBMSessionInfoViewController  {
    
    func applyStyle() {
        gradientLayerColors = style.gradient
    }
    
    func setupScrollView() {
        helpMessages.forEach { (message) in
            let messageView = messageLabel(withText: message)
            scrollView.addSubview(messageView)
        }
        
        func messageLabel(withText text: String) -> UILabel {
            let label = UILabel(frame: .zero)
            label.attributedText = messageTextStyle.attributedString(with: text, color: style.textColor4)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.backgroundColor = .clear
            label.minimumScaleFactor = 0.8
            return label
        }
    }
    
    func layoutScrollView() {
        let margin = scrollView.frame.minX

        scrollView.subviews.forEach { (view) in
            guard let index = scrollView.subviews.index(of: view) else {return}
            view.frame = CGRect(x: CGFloat(index) * scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            view.sizeToFit()
        }
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(helpMessages.count), height: scrollView.bounds.height)
    }
    
    func layoutIcons() {
        let margin: CGFloat = 10.0
        
        clockImageView.center = CGPoint(x: view.frame.midX,
                                        y: iconsContainer.bounds.midY)
        
        probeA_ImageView.center = CGPoint(x: view.frame.midX * 3.0 - probeA_ImageView.bounds.midX - margin,
                                          y: iconsContainer.bounds.midY)
        
        probeB_ImageView.center =  CGPoint(x: view.frame.midX * 3.0 + probeB_ImageView.bounds.midX + margin,
                                           y: iconsContainer.bounds.midY)

    }
    
    
    func secondPageLayout() {
        let margin: CGFloat = 10.0
        
        clockImageView.center = CGPoint(x: -view.frame.midX,
                                        y: iconsContainer.bounds.midY)

        probeA_ImageView.center = CGPoint(x: view.frame.midX - probeA_ImageView.bounds.midX - margin,
                                          y: iconsContainer.bounds.midY)

        probeB_ImageView.center =  CGPoint(x: view.frame.midX + probeB_ImageView.bounds.midX + margin,
                                           y: iconsContainer.bounds.midY)
    }

    func runActionButtonAnimation() {
        actionButtonTopSpaceConstraint.constant = 0

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.7, options: .curveLinear, animations: {[weak self] in
            guard let sself = self else { return }
            sself.view.layoutIfNeeded()
        })
    }
    
    func runFullAnimation() {

        interactiveAnimator = nil
        scrollView.isUserInteractionEnabled = false
        let margin: CGFloat = 10.0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {[weak self] in
            guard let sself = self else { return }
            sself.clockImageView.center = CGPoint(x: -sself.view.frame.midX,
                                                  y: sself.iconsContainer.bounds.midY)
            sself.scrollView.contentOffset = CGPoint(x: sself.scrollView.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {[weak self] in
            guard let sself = self else { return }
            sself.probeA_ImageView.center = CGPoint(x: sself.view.frame.midX - sself.probeA_ImageView.bounds.midX - margin,
                                                    y: sself.iconsContainer.bounds.midY)
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.15, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {[weak self] in
            guard let sself = self else { return }
            sself.probeB_ImageView.center =  CGPoint(x: sself.view.frame.midX + sself.probeB_ImageView.bounds.midX + margin,
                                                     y: sself.iconsContainer.bounds.midY)
        }, completion: {[weak self] (finish) in
            self?.setupInteractiveAnimator()
            self?.scrollView.isUserInteractionEnabled = true
            self?.updatePage()
        })
    }
}


extension CBMSessionInfoViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.horizontalScrollPercentage
        guard let animator = interactiveAnimator, offset > 0 else { return }
        
        if !animator.isRunning {
            animator.fractionComplete = offset
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       updatePage()
    }
    
    func updatePage() {
        let currentPage = scrollView.horizontalPage
        guard currentPage != pageControl.currentPage else { return }
        let buttonTitle = (currentPage == 0) ? "Next" : "Start"
        actionButton.setTitle(buttonTitle, for: .normal)
        pageControl.currentPage = currentPage
    }
    
}

extension CBMSessionInfoViewController: MaterialTransitionInitialFrameProvider {
    
    var initialFrame: CGRect {
        get {
            let frame = self.view.convert(actionButton.bounds, from: actionButton)
            return frame
        }
    }
    
    var initialView: UIView {
        get {
            let view = UIView(frame: actionButton.frame)
            view.backgroundColor = actionButton.backgroundColor
            view.layer.cornerRadius = actionButton.layer.cornerRadius
            return view
        }
    }
}


