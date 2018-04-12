//
//  ChangeStageViewController.swift
//  Pods
//
//  Created by Marc Blasi on 19/09/2017.
//
//

import UIKit

class ChangeStageViewController: MFLViewController {
    
    @IBOutlet var tableView: UITableView!
    var presenter : ChangeStagePresenter!
    var cellFactory : CellFactory!
    var style: Style!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gradientLayerColors = style.gradient
        self.gradientStartPoint = CGPoint(x: 0.25, y: 0.0)
        self.gradientEndPoint = CGPoint(x: 0.75, y: 1.0)
        self.shouldUseGradientBackground = true
        
        cellFactory = CellFactory(container: tableView)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
    }
}

extension ChangeStageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfStages
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stageDisplay = presenter.stage(at: indexPath.row)
        
        let cell = cellFactory.dequeueReusableCell(StageCell.self, at: indexPath, in: .stages)
        cell.stageView.leftLabel.text = "\(stageDisplay.index)"
        cell.stageView.titleLabel.text = stageDisplay.title
        if stageDisplay.selected {
            cell.stageView.accessoryImage.setImageTemplate(named: "success_mark_green", in: .common, color: .white)
        }
        else {
            cell.stageView.accessoryImage.image = nil
        }
        
        return cell
    }
}

extension ChangeStageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.selectStage(at: indexPath.row)
        tableView.reloadData()
    }
}

extension  ChangeStageViewController : ChangeStagePresenterDelegate {
    
}

