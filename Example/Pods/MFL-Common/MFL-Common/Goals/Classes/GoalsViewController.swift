//
//  GoalsViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD
import StatefulViewController

fileprivate let ongoingGoalsSegueId = "OngoingGoalsSegue"
fileprivate let completedGoalsSegueId = "CompletedGoalsSegue"

class GoalsViewController: MFLViewController, StatefulViewController {

    fileprivate enum Mode {
        case ongoing
        case completed
    }
    fileprivate var mode: Mode = .ongoing {
        didSet {
            switch mode {
            case .ongoing:
                ongoingGoalsView.isHidden = false
                completedGoalsView.isHidden = true
                navigationItem.leftBarButtonItems = ongoingGoalsViewController.navigationItem.leftBarButtonItems
                navigationItem.rightBarButtonItems = ongoingGoalsViewController.navigationItem.rightBarButtonItems
            case .completed:
                ongoingGoalsView.isHidden = true
                completedGoalsView.isHidden = false
                navigationItem.leftBarButtonItems = completedGoalsViewController.navigationItem.leftBarButtonItems
                navigationItem.rightBarButtonItems = completedGoalsViewController.navigationItem.rightBarButtonItems
            }
        }
    }
    
    var presenter : GoalsPresenter!
    var style : Style!
    
    fileprivate weak var ongoingGoalsViewController : OngoingGoalsViewController!
    fileprivate weak var completedGoalsViewController : CompletedGoalsViewController!
    
    @IBOutlet weak var ongoingGoalsView: UIView!
    @IBOutlet weak var completedGoalsView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        gradientLayerColors = style.gradient
        shouldUseGradientBackground = true
        
        mode = .ongoing
        
        let refreshView = MFLRefreshView()
        refreshView.backgroundColor = .mfl_nearWhite
        
        let primaryColor = style != nil ? style!.primary : .mfl_green
        
        let textColor = style != nil ? style!.textColor1 : .mfl_greyishBrown
        refreshView.attributedText = NSLocalizedString("We couldn’t sync your goals", comment: "").attributedString(style: .bigText, color: textColor, alignment: .center)
        refreshView.buttonTitle = NSLocalizedString("Refresh to Update", comment: "")
        refreshView.buttonBackgroundColor = primaryColor
        refreshView.refreshImageColor = primaryColor
        refreshView.action = { [weak self] in self?.fetchGoals() }
        errorView = refreshView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchGoals()
    }
    
    func hasContent() -> Bool {
        return (presenter.numberOfOngoingGoals + presenter.numberOfCompletedGoals) > 0
    }
    
    func handleErrorWhenContentAvailable(_ error: Error) {
        showAlert(for: error)
    }
    
    @IBAction func goalsSegmentedControlValueChanged(_ sender: Any) {
        
        guard let segmentedControl = sender as? UISegmentedControl else { return }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: mode = .ongoing
        case 1: mode = .completed
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == ongoingGoalsSegueId {
            ongoingGoalsViewController = segue.destination as! OngoingGoalsViewController
            ongoingGoalsViewController.presenter = presenter
            ongoingGoalsViewController.style = style
        }
        else if segue.identifier == completedGoalsSegueId {
            completedGoalsViewController = segue.destination as! CompletedGoalsViewController
            completedGoalsViewController.presenter = presenter
            completedGoalsViewController.style = style
        }
    }
    
    fileprivate func fetchGoals() {
        if !hasContent() { HUD.show(.progress) }
        presenter.fetchGoals()
    }
}

extension  GoalsViewController : GoalsPresenterDelegate {
    
    func goalsPresenter(_ sender: GoalsPresenter, didFinishFetchGoalsWith error: Error?) {
        
        HUD.hide()
   
        ongoingGoalsViewController.reload()
        completedGoalsViewController.reload()
        
        transitionViewStates(loading: false, error: error, animated: true, completion: nil)
    }
    
    func goalsPresenter(_ sender: GoalsPresenter, didFinishDeleteOfOngoingGoalAt index: Int, with error: Error?) {
        
        HUD.hide()
        if let error = error {
            showAlert(for: error)
        } else {
            ongoingGoalsViewController.tableView.beginUpdates()
            ongoingGoalsViewController.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            ongoingGoalsViewController.tableView.endUpdates()
        }
    }
    
    func goalsPresenter(_ sender: GoalsPresenter, didFinishDeleteOfCompletedGoalAt index: Int, with error: Error?) {
        
        HUD.hide()
        if let error = error {
            showAlert(for: error)
        } else {
            completedGoalsViewController.tableView.beginUpdates()
            completedGoalsViewController.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            completedGoalsViewController.tableView.endUpdates()
        }
    }
    
    func goalsPresenter(_ sender: GoalsPresenter, wantsToShow alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

