//
//  OnboardingViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 18/09/2017.
//
//

import UIKit
import SpriteKit

fileprivate let viewController1_segueID = "viewController1_segueID"
fileprivate let viewController2_segueID = "viewController2_segueID"
fileprivate let viewController3_segueID = "viewController3_segueID"

class OnboardingViewController: MFLViewController {
    
    var presenter : OnboardingPresenter!
    var style : Style!
    
    @IBOutlet weak var scrollView: UIScrollView!
    fileprivate var viewController1 : OnboardingChildViewController1!
    fileprivate var viewController2 : OnboardingChildViewController2!
    fileprivate var viewController3 : OnboardingChildViewController3!
    
    fileprivate var currentPage = 0
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: RoundedButton!
    @IBOutlet weak var signInInfoLabel: UILabel!
    @IBOutlet weak var signInActionLabel: UILabel!
    fileprivate let signInActionLabelFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightSemibold)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesNavigationBar = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signInTapped(_:)))
        signInActionLabel.addGestureRecognizer(tapGesture)
        
        viewController1.style = style
        viewController1.text = presenter.copyScreen1
        
        viewController2.style = style
        viewController2.text = presenter.copyScreen2
        
        viewController3.style = style
        viewController3.text = presenter.copyScreen3
        
        applyStyle()
    }
    
    func applyStyle() {
        
        gradientLayerColors = style.gradient
        shouldUseGradientBackground = true
        
        signInInfoLabel.textColor = style.textColor4
        
        let signInString = NSLocalizedString("Sign in", comment: "")
        let range = signInString.fullRange
        let singInAttrText = NSMutableAttributedString(string: signInString)
        singInAttrText.setFont(signInActionLabelFont)
        singInAttrText.setColor(style.textColor4)
        singInAttrText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        singInAttrText.addAttribute(NSUnderlineColorAttributeName, value: style.textColor4, range: range)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        presenter.userWantsToSingIn()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == viewController1_segueID, let viewController = segue.destination as? OnboardingChildViewController1 {
            viewController1 = viewController
        } else if segue.identifier == viewController2_segueID, let viewController = segue.destination as? OnboardingChildViewController2 {
            viewController2 = viewController
        } else if segue.identifier == viewController3_segueID, let viewController = segue.destination as? OnboardingChildViewController3 {
            viewController3 = viewController
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewController1.parentDidLayoutSubviews()
        viewController3.parentDidLayoutSubviews()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        
        if currentPage == 2 {
            presenter.userWantsToContinue()
            return
        }
        
        scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: CGFloat(currentPage + 1) * scrollView.width, y: 0.0),
                                              size: scrollView.frame.size), animated: true)
        updateNextButtonStyle()
    }
    
    fileprivate func updateNextButtonStyle() {
        if currentPage == 2 {
            nextButton.borderColor = .clear
            nextButton.setTitleColor(style.primary, for: .normal)
            nextButton.backgroundColor = style.textColor4
            nextButton.setTitle(NSLocalizedString("Continue", comment: ""), for:.normal)
        } else {
            nextButton.borderColor = style.textColor4
            nextButton.setTitleColor(style.textColor4, for: .normal)
            nextButton.backgroundColor = .clear
            nextButton.setTitle(NSLocalizedString("Next", comment: ""), for:.normal)
        }
    }
    
}

extension OnboardingViewController : OnboardingPresenterDelegate {
    
}

extension OnboardingViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = scrollView.horizontalPage
        
        if pageControl.currentPage != currentPage {
            currentPage = pageControl.currentPage
            if currentPage == 1 { viewController2.animate() }
            else { viewController2.setToInitialState() }
        }
        
        updateNextButtonStyle()
    }
}
