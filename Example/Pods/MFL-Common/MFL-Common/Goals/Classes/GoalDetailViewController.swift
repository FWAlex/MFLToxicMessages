//
//  GoalDetailViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD

private let disclaimerLabelTextStyle = TextStyle.smallText

class GoalDetailViewController: UIViewController {
    
    var presenter : GoalDetailPresenter!
    var style : Style!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var titleTextField: MFLTextView!
    @IBOutlet weak var descriptionTextField: MFLTextView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var mountainContainerView: HitTestInsetsView!
    @IBOutlet weak var mountainView: MountainView!
    @IBOutlet weak var mountainViewSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mountainViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate lazy var closeBarButton : UIBarButtonItem = {
        let button = UIButton()
        let image = UIImage.template(named: "close_white", in: .common)
        button.setImage(image, for: .normal)
        button.tintColor = self.style.primary
        button.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
        button.sizeToFit()
        
        return UIBarButtonItem(customView: button)
    }()
    
    fileprivate lazy var saveBarButton : UIBarButtonItem = {
       let button = UIBarButtonItem(barButtonSystemItem: .save,
                                    target: self,
                                    action: #selector(GoalDetailViewController.saveTapped))
        
        return button
    }()
    
    override var canBecomeFirstResponder: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = closeBarButton
        navigationItem.rightBarButtonItem = saveBarButton
        
        disclaimerLabel.attributedText = disclaimerLabel.attributedText?.attributedString(style: disclaimerLabelTextStyle,
                                                                                          color: style.textColor2,
                                                                                          alignment: .center)
        
        titleTextField.delegate = self
        titleTextField.maxExpansionHeight = 60
        titleTextField.textColor = style.textColor1
        titleTextField.placeholderDefaultColor = style.primary
        titleTextField.separatorSuccessColor = style.primary
        titleTextField.textView.autocorrectionType = .default
        titleTextField.textView.tintColor = style.primary
        
        descriptionTextField.delegate = self
        descriptionTextField.maxExpansionHeight = 150
        descriptionTextField.textColor = style.textColor1
        descriptionTextField.placeholderDefaultColor = style.primary
        descriptionTextField.separatorSuccessColor = style.primary
        descriptionTextField.textView.autocorrectionType = .default
        descriptionTextField.textView.tintColor = style.primary
        
        infoLabel.textColor = style.textColor2
        
        mountainContainerView.hitTestInsets = UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)
        mountainView.hitTestInsets = mountainContainerView.hitTestInsets
        mountainView.delegate = self
        mountainView.style = style
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
        view.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        update(with: presenter.goal)
        validate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateConstraints()
    }
    
    // MARK: Actions
    
    @objc fileprivate func didTapClose(_ sender: Any) {
        
        presenter.userWantsToClose(title: titleTextField.text, desc: descriptionTextField.text, progress: mountainView.currentProgress)
    }
    
    @objc fileprivate func saveTapped(_ sender: Any) {
        
        _ = becomeFirstResponder()
        
        guard let title = titleTextField.text, let desc = descriptionTextField.text else { return }
        
        HUD.show(.progress)
        
        presenter.userWantsToSaveGoal(title: title,
                                      desc: desc,
                                      progress: mountainView.currentProgress)
    }
    
    @objc fileprivate func endEditing(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
            _ = becomeFirstResponder()
        }
    }
    
    // MARK: Private
    
    fileprivate func update(with goal: DisplayGoalDetail) {
        
        titleTextField.text = goal.title
        descriptionTextField.text = goal.desc
        mountainView.currentProgress = goal.progress
    }
    
    fileprivate func validate() {
        
        guard presenter.canEditGoal() else {
            
            // assuming that we never go back to editable from non-editable
            
            titleTextField.isUserInteractionEnabled = false
            descriptionTextField.isUserInteractionEnabled = false
            mountainView.isEditable = false
            navigationItem.rightBarButtonItem = nil
            
            return
        }
        
        let valid = presenter.canSaveGoal(title: titleTextField.text, desc: descriptionTextField.text, progress: mountainView.currentProgress)
        
        saveBarButton.isEnabled = valid
    }
    
    fileprivate func updateConstraints() {
        
        let aspectRatio: CGFloat = MountainView.referenceBoundsSize.width / MountainView.referenceBoundsSize.height
        let height: CGFloat = view.frame.width / aspectRatio
        
        mountainViewSpacingConstraint.constant = height
        
        let bottomOffset = scrollView.contentSize.height - scrollView.bounds.height
        let positiveOffset = max(0.0, scrollView.contentOffset.y - bottomOffset)
        
        mountainViewHeightConstraint.constant = height + positiveOffset
    }
}

extension GoalDetailViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateConstraints()
    }
}

extension GoalDetailViewController : GoalDetailPresenterDelegate {
    
    func goalDetailPresenter(_ sender: GoalDetailPresenter, didFinishSavingGoalWith error: Error?) {
        HUD.hide()
        if let error = error {
            showAlert(for: error)
        }
    }
    
    func goalDetailPresenter(_ sender: GoalDetailPresenter, wantsToShow alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

extension GoalDetailViewController : MFLTextViewDelegate {
    
    func mflTextViewEditingChanged(_ sender: MFLTextView) {
        validate()
    }
}

extension GoalDetailViewController : MountainViewDelegate {
    
    func mountainView(_ sender: MountainView, didUpdate progress: Int) {
        MFLAnalytics.record(event: .buttonTap(name: "Goal Rating Changed", value: progress as NSNumber))
        validate()
    }
    
    func mountainView(_ sender: MountainView, didRequestMoreOptions: @escaping ((Bool) -> Void)) {
        presenter.userWantsToShowMoreOption(action: didRequestMoreOptions)
    }
    
    func mountainViewShouldShowMoreAction(_ sender: MountainView) -> Bool {
        return presenter.shouldShowMoreOptionGoal()
    }
}
