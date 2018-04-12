//
//  CompletedGoalsViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD
import StatefulViewController

class CompletedGoalsViewController : MFLViewController, StatefulViewController {
    
    var presenter : GoalsPresenter!
    var style : Style!
    var cellFactory : CellFactory!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellFactory = CellFactory(container: tableView)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 114
        tableView.rowHeight = UITableViewAutomaticDimension
        
        headerLabel.textColor = style.textColor4
        
        gradientLayerColors = style.gradient
        shouldUseGradientBackground = true
        
        let completedGoalsEmptyView = CompletedGoalsEmptyView.mfl_viewFromNib(bundle: .goals) as! CompletedGoalsEmptyView
        completedGoalsEmptyView.style = style
        emptyView = completedGoalsEmptyView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupInitialViewState()
    }
    
    func hasContent() -> Bool {
        return presenter.numberOfCompletedGoals > 0
    }
    
    func reload() {
        transitionViewStates()
        tableView.reloadData()
    }
}

extension CompletedGoalsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCompletedGoals
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let goal = presenter.completedGoal(at: indexPath.row)
        
        let cell = cellFactory.dequeueReusableCell(GoalCell.self, at: indexPath, in: .goals)
        cell.title = goal.title
        cell.desc = goal.desc
        cell.progress = goal.progress
        cell.isExample = goal.isExample
        if cell.style == nil { cell.style = style }
        
        return cell
    }
}

extension CompletedGoalsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.userWantsToViewCompletedGoal(at: indexPath.row)
    }
}
