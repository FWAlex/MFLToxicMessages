//
//  GoalsPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

fileprivate let totalNumberOfOngoingGoals = 10
fileprivate let goalCompletedProgress = 10

class GoalsPresenterImplementation: GoalsPresenter {
    
    weak var delegate : GoalsPresenterDelegate?
    let interactor: GoalsInteractor
    let wireframe: GoalsWireframe
    
    fileprivate var ongoingGoals = [Goal]()
    fileprivate var completedGoals = [Goal]()
    
    init(interactor: GoalsInteractor, wireframe: GoalsWireframe) {
        self.interactor = interactor
        self.wireframe = wireframe
    }
    
    func fetchGoals() {
        interactor.fetchGoals() { [unowned self] result in
            
            switch result {
            case .success(let goals):
                self.updateGoals(goals)
                self.delegate?.goalsPresenter(self, didFinishFetchGoalsWith: nil)
            case .failure(let error, let storedGoals):
                if let storedGoals = storedGoals { self.updateGoals(storedGoals) }
                self.delegate?.goalsPresenter(self, didFinishFetchGoalsWith: error)
            }
        }
    }
    
    var numberOfOngoingGoals : Int {
        return ongoingGoals.count
    }
    
    var numberOfFreeGoalSlots : Int {
        
        let freeSlots = totalNumberOfOngoingGoals - numberOfOngoingGoals
        
        return freeSlots < 0 ? 0 : freeSlots
    }
    
    var numberOfCompletedGoals : Int {
        return completedGoals.count
    }
    
    var hasExampleGoals : Bool {
        return ongoingGoals.filter({ $0.isExample }).isEmpty == false
    }
    
    func userWantsToAddNewGoal() {
        MFLAnalytics.record(event: .buttonTap(name: "Add Goal Tapped", value: nil))
        if hasExampleGoals || numberOfFreeGoalSlots > 0 {
            wireframe.presentNewGoalPage()
        } else {
            showGoalLimitAlert()
        }
    }
    
    func ongoingGoal(at index: Int) -> DisplayGoal {
        return DisplayGoal(ongoingGoals[index])
    }
    
    func completedGoal(at index: Int) -> DisplayGoal {
        return DisplayGoal(completedGoals[index])
    }
    
    func userWantsToViewOngoingGoal(at index: Int) {
        wireframe.presentGoalDetailsPage(for: ongoingGoals[index])
    }
    
    func userWantsToViewCompletedGoal(at index: Int) {
        wireframe.presentGoalDetailsPage(for: completedGoals[index])
    }
    
    func userWantsToDeleteOngoingGoal(at index: Int) {
        
        interactor.delete(ongoingGoals[index]) { [unowned self] result in
            
            switch result {
            case .success:
                self.ongoingGoals.remove(at: index)
                self.delegate?.goalsPresenter(self, didFinishDeleteOfOngoingGoalAt: index, with: nil)
            case .failure(let error):
                self.delegate?.goalsPresenter(self, didFinishDeleteOfOngoingGoalAt: index, with: error)
            }
        }
    }
    
    func userWantsToDeleteCompletedGoal(at index: Int) {
        
        interactor.delete(completedGoals[index]) { [unowned self] result in
            
            switch result {
            case .success:
                self.completedGoals.remove(at: index)
                self.delegate?.goalsPresenter(self, didFinishDeleteOfCompletedGoalAt: index, with: nil)
            case .failure(let error):
                self.delegate?.goalsPresenter(self, didFinishDeleteOfCompletedGoalAt: index, with: error)
            }
        }
    }
    
    fileprivate func updateGoals(_ goals: [Goal]) {
        self.ongoingGoals = goals.filter() { !self.isComplete($0) }
        self.completedGoals = goals.filter() { self.isComplete($0) }
    }
    
    fileprivate func isComplete(_ goal: Goal) -> Bool {
        return goal.progress == goalCompletedProgress
    }
}

extension DisplayGoal {
   
    init(_ goal: Goal) {
        title = goal.title
        desc = goal.desc
        progress = goal.progress
        isExample = goal.isExample
    }
}

extension GoalsPresenterImplementation {

    func showGoalLimitAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Goal Limit", comment: ""),
                                      message: NSLocalizedString("Why don't you focus on the goals you've already set. Once you achieve one goal you can add another.", comment: ""),
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel)
        alert.addAction(cancelAction)

        delegate?.goalsPresenter(self, wantsToShow: alert)
    }
}
