//
//  GoalDetailPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

fileprivate let goalCompletedProgress = 10

class GoalDetailPresenterImplementation: GoalDetailPresenter {
    
    weak var delegate : GoalDetailPresenterDelegate?
    let interactor: GoalDetailInteractor
    let wireframe: GoalDetailWireframe
    
    fileprivate var _goal : Goal?
    
    init(goal: Goal?, interactor: GoalDetailInteractor, wireframe: GoalDetailWireframe) {
        self.interactor = interactor
        self.wireframe = wireframe
        _goal = goal
        self.goal = DisplayGoalDetail(_goal)
    }
    
    deinit {
        interactor.rollback()
    }
    
    let goal : DisplayGoalDetail
    
    func userWantsToDeleteGoal() {
        if let goal = _goal {
            interactor.delete(goal) { [unowned self] _ in
                self.wireframe.dismiss()
            }
        }
    }
    
    func userWantsToSaveGoal(title: String, desc: String, progress: Int) {
        
        MFLAnalytics.record(event: .buttonTap(name: "Save Goal Tapped", value: nil))
        
        if var goal = _goal {
            goal.title = title
            goal.desc = desc
            goal.progress = progress
            interactor.save(goal) { [unowned self] _ in
                self.delegate?.goalDetailPresenter(self, didFinishSavingGoalWith: nil)
                if self.isComplete(goal) { self.wireframe.showGoalComplete() }
                else { self.wireframe.dismiss() }
            }
        }
        else {
            interactor.newGoal(title: title,
                               desc: desc,
                               progress: progress) { [unowned self] result in
                                
                                switch result {
                                case .success(let goal):
                                    self.delegate?.goalDetailPresenter(self, didFinishSavingGoalWith: nil)
                                    if self.isComplete(goal) { self.wireframe.showGoalComplete() }
                                    else { self.wireframe.dismiss() }
                                case .failure(let error):
                                    self.delegate?.goalDetailPresenter(self, didFinishSavingGoalWith: error)
                                }
            }
        }
    }
    
    func userWantsToClose(title: String?, desc: String?, progress: Int) {
        
        let close = {
            self.interactor.rollback()
            self.delegate?.goalDetailPresenter(self, didFinishSavingGoalWith: nil)
            self.wireframe.dismiss()
        }
        
        if hasChanges(title: title, desc: desc, progress: progress) {
            showDiscardAlert(action: { discard in
                if discard { close() }
            })
        } else {
            close()
        }
    }
    
    func canEditGoal() -> Bool {
        guard let goal = _goal else { return true }
        return goal.isExample == false && isComplete(goal) == false
    }
    
    func shouldShowMoreOptionGoal() -> Bool {
        return _goal == nil || _goal?.progress == 10
    }
    
    func canSaveGoal(title: String?, desc: String?, progress: Int) -> Bool {
        
        var valid = true
        valid = valid && mfl_nilOrEmpty(title) == false
        valid = valid && mfl_nilOrEmpty(desc) == false
        
        let hasChanges = self.hasChanges(title: title, desc: desc, progress: progress)
        
        return valid && hasChanges
    }
    
    func userWantsToShowMoreOption(action: @escaping ((Bool) -> Void)) {
        showMoreOptions(action: action)
    }
    
    fileprivate func hasChanges(title: String?, desc: String?, progress: Int) -> Bool {
        
        var hasChanges = false
        hasChanges = hasChanges || title != goal.title
        hasChanges = hasChanges || desc != goal.desc
        hasChanges = hasChanges || progress != goal.progress
        
        return hasChanges
    }
    
    fileprivate func isComplete(_ goal: Goal) -> Bool {
        return goal.progress == goalCompletedProgress
    }
}

extension DisplayGoalDetail {
    
    init(_ goal: Goal?) {
        title = goal?.title ?? ""
        desc = goal?.desc ?? ""
        progress = goal?.progress ?? 0
    }
}

extension GoalDetailPresenterImplementation {
    
    func showDiscardAlert(action: @escaping ((Bool) -> Void)) {
        let alert = UIAlertController(title: NSLocalizedString("Discard Changes", comment: ""),
                                      message: NSLocalizedString("You are about to discard your changes. Are you sure you want to close without saving?", comment: ""),
                                      preferredStyle: .alert)
        let discardAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive) { _ in action(true) }
        let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel) { _ in action(false) }
        alert.add([cancelAction, discardAction])
        alert.preferredAction = cancelAction
        
        delegate?.goalDetailPresenter(self, wantsToShow: alert)
    }
    
    func showResetAlert(action: @escaping ((Bool) -> Void)) {
        let alert = UIAlertController(title: NSLocalizedString("Reset Progress", comment: ""),
                                      message: NSLocalizedString("You are about to reset your progress. Are you sure you want to start over?", comment: ""),
                                      preferredStyle: .alert)
        let resetAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { _ in action(true) }
        let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel) { _ in action(false) }
        alert.add([cancelAction, resetAction])
        alert.preferredAction = resetAction
        
        delegate?.goalDetailPresenter(self, wantsToShow: alert)
    }
    
    func showMoreOptions(action: @escaping ((Bool) -> Void)) {
        MFLAnalytics.record(event: .buttonTap(name: "Goal Edit Tapped", value: nil))
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        var actions: [UIAlertAction] = []
        
        if self._goal != nil {
            if self.goal.progress != 0 {
                actions.append(UIAlertAction(title: NSLocalizedString("Reset Progress", comment: ""), style: .default) {[unowned self] (_) in
                    MFLAnalytics.record(event: .buttonTap(name: "Goal Reset Progress Tapped", value: nil))
                    self.showResetAlert(action: action)
                })
            }
            
            actions.append(UIAlertAction(title:  NSLocalizedString("Delete Goal", comment: ""), style: .default) { (_) in
                MFLAnalytics.record(event: .buttonTap(name: "Goal Delete Tapped", value: nil))
                self.userWantsToDeleteGoal()
            })
        }
        actions.append(UIAlertAction(title:  NSLocalizedString("Cancel", comment: ""), style: .cancel) { (_) in
            actionSheet.dismiss(animated: true, completion: nil)
        })
        
        actionSheet.add(actions)
        delegate?.goalDetailPresenter(self, wantsToShow: actionSheet)
    }
}
