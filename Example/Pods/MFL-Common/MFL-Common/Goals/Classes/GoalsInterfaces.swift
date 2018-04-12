//
//  GoalsInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit


//MARK: - Interactor

protocol GoalsInteractorDelegate : class {
    
}

protocol GoalsInteractor {
    
    weak var delegate : GoalsInteractorDelegate? { get set }
    
    func fetchGoals(handler: @escaping (UpdateResult<[Goal]>) -> Void)
    func delete(_ goal: Goal, handler: @escaping (Result<String>) -> Void)
}

//MARK: - Presenter

protocol GoalsPresenterDelegate : class {
    
    func goalsPresenter(_ sender: GoalsPresenter, didFinishFetchGoalsWith error: Error?)
    func goalsPresenter(_ sender: GoalsPresenter, didFinishDeleteOfOngoingGoalAt index: Int, with error: Error?)
    func goalsPresenter(_ sender: GoalsPresenter, didFinishDeleteOfCompletedGoalAt index: Int, with error: Error?)
    func goalsPresenter(_ sender: GoalsPresenter, wantsToShow alert: UIAlertController)
}

protocol GoalsPresenter {
    
    weak var delegate : GoalsPresenterDelegate? { get set }
    
    func fetchGoals()
    
    var numberOfOngoingGoals : Int { get }
    var numberOfFreeGoalSlots : Int { get }
    
    var numberOfCompletedGoals : Int { get }
    
    var hasExampleGoals : Bool { get }
    
    func ongoingGoal(at index: Int) -> DisplayGoal
    func completedGoal(at index: Int) -> DisplayGoal
    
    func userWantsToAddNewGoal()
    func userWantsToViewOngoingGoal(at index: Int)
    func userWantsToViewCompletedGoal(at index: Int)
    func userWantsToDeleteOngoingGoal(at index: Int)
    func userWantsToDeleteCompletedGoal(at index: Int)
}

//MARK: - Wireframe

protocol GoalsWireframeDelegate : class {
    func goalsWireframeWantsToPresentNewGoalPage(_ sender: GoalsWireframe)
    func goalsWireframe(_ sender: GoalsWireframe, wantsToPresentDetailsPageFor goal: Goal)
}

protocol GoalsWireframe {
    
    weak var delegate : GoalsWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasGoalDataStore & HasStyle)
    
    func presentNewGoalPage()
    func presentGoalDetailsPage(for goal: Goal)
}
