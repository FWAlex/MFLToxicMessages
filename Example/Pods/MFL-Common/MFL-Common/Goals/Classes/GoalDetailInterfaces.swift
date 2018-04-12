//
//  GoalDetailInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit


//MARK: - Interactor

protocol GoalDetailInteractorDelegate : class {
    
}

protocol GoalDetailInteractor {
    
    weak var delegate : GoalDetailInteractorDelegate? { get set }
    
    func newGoal(title: String, desc: String, progress: Int, handler: @escaping (Result<Goal>) -> Void)
    func save(_ goal: Goal, handler: @escaping (Result<Goal>) -> Void)
    func delete(_ goal: Goal, handler: @escaping (Result<String>) -> Void)
    func rollback()
}

//MARK: - Presenter

protocol GoalDetailPresenterDelegate : class {
    func goalDetailPresenter(_ sender: GoalDetailPresenter, didFinishSavingGoalWith error: Error?)
    func goalDetailPresenter(_ sender: GoalDetailPresenter, wantsToShow alert: UIAlertController)
}

protocol GoalDetailPresenter {
    
    weak var delegate : GoalDetailPresenterDelegate? { get set }
    
    var goal : DisplayGoalDetail { get }
    func userWantsToDeleteGoal()
    func userWantsToSaveGoal(title: String, desc: String, progress: Int)
    func userWantsToClose(title: String?, desc: String?, progress: Int)
    func canEditGoal() -> Bool
    func shouldShowMoreOptionGoal() -> Bool
    func canSaveGoal(title: String?, desc: String?, progress: Int) -> Bool
    func userWantsToShowMoreOption(action: @escaping ((Bool) -> Void))
}

//MARK: - Wireframe

protocol GoalDetailWireframeDelegate : class {
    
}

protocol GoalDetailWireframe {
    
    weak var delegate : GoalDetailWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasGoalDataStore & HasStyle, goal: Goal?)
    
    func dismiss()
    
    func showGoalComplete()
}
