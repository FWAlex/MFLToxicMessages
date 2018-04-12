//
//  OngoingGoalsViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD

class OngoingGoalsTableView: UITableView {
    
    let inset: CGFloat = 4
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height + inset * 2)
    }
}

class OngoingGoalsViewController: UIViewController {

    var presenter : GoalsPresenter!
    var style : Style!
    var cellFactory : CellFactory!
    
    fileprivate lazy var addBarButton : UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add,
                                     target: self,
                                     action: #selector(OngoingGoalsViewController.addTapped))
        
        return button
    }()
    
    @IBOutlet weak var headerView: GoalsHeaderView!
    @IBOutlet weak var tableView: OngoingGoalsTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = addBarButton
        
        cellFactory = CellFactory(container: tableView)
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 114
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsets(top: tableView.inset, left: 0, bottom: tableView.inset, right: 0)
        
        headerView.style = style
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        setEditing(false, animated: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: animated)
    }
    
    func reload() {
        headerState = presenter.hasExampleGoals ? .examples : .none
        tableView.reloadData()
        tableView.invalidateIntrinsicContentSize()
    }
    
    // MARK: Actions
    
    @objc fileprivate func editTapped(_ sender: Any) {
        setEditing(true, animated: true)
        
    }
    
    @objc fileprivate func doneTapped(_ sender: Any) {
        setEditing(false, animated: true)
    }
    
    @objc fileprivate func addTapped(_ sender: Any) {
        presenter.userWantsToAddNewGoal()
    }
    
    // MARK: Header
    
    enum HeaderState {
        case none
        case examples
    }
    
    var headerState: HeaderState = .none {
        didSet {
            switch headerState {
            case .none:
                headerView.isSecondaryLabelHidden = true
                tableView.alwaysBounceVertical = true
            case .examples:
                headerView.isSecondaryLabelHidden = false
                tableView.alwaysBounceVertical = false
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }

    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        
        tableView.tableHeaderView = headerView
    }
}

extension OngoingGoalsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfOngoingGoals
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let goal = presenter.ongoingGoal(at: indexPath.row)
        
        let cell = cellFactory.dequeueReusableCell(GoalCell.self, at: indexPath, in: .goals)
            
        cell.title = goal.title
        cell.desc = goal.desc
        cell.progress = goal.progress
        cell.isExample = goal.isExample
        if cell.style == nil { cell.style = style }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            HUD.show(.progress)
            presenter.userWantsToDeleteOngoingGoal(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let goal = presenter.ongoingGoal(at: indexPath.row)
        return goal.isExample == false
    }
}

extension OngoingGoalsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.userWantsToViewOngoingGoal(at: indexPath.row)
    }
}
