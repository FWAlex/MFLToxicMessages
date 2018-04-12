//
//  GoalsFlow.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

open class GoalsFlow {
    
    fileprivate lazy var dependencies : GoalsDependencies = {
        var dependencies = GoalsDependencies()
        dependencies.storyboard = UIStoryboard(name: "Goals", bundle: .goals)
        
        return dependencies
    }()

    public init() { }
    
    public func start(_ dependencies: HasNavigationController & HasNetworkManager & HasGoalDataStore & HasStyle) {
        self.dependencies.navigationController = dependencies.navigationController
        self.dependencies.networkManager = dependencies.networkManager
        self.dependencies.goalDataStore = dependencies.goalDataStore
        self.dependencies.style = dependencies.style
        
        moveToGoalsPage()
    }
}

//MARK: - Navigation

extension GoalsFlow {
    
    func moveToGoalsPage() {
        
        var wireframe = GoalsFactory.wireframe()
        wireframe.delegate = self
        wireframe.start(dependencies)
    }
    
    func moveToGoalDetailPage(_ goal: Goal?) {
        GoalDetailFactory.wireframe().start(dependencies, goal: goal)
    }
}

//MARK: - GoalsWireframeDelegate
extension GoalsFlow : GoalsWireframeDelegate {
    
    func goalsWireframeWantsToPresentNewGoalPage(_ sender: GoalsWireframe) {
        moveToGoalDetailPage(nil)
    }
    
    func goalsWireframe(_ sender: GoalsWireframe, wantsToPresentDetailsPageFor goal: Goal) {
        moveToGoalDetailPage(goal)
    }
}

//MARK: - Dependencies
struct GoalsDependencies : HasNetworkManager, HasNavigationController, HasStoryboard, HasGoalDataStore, HasStyle {
    var networkManager: NetworkManager!
    var navigationController: UINavigationController!
    var storyboard: UIStoryboard!
    var goalDataStore: GoalDataStore!
    var style: Style!
}
