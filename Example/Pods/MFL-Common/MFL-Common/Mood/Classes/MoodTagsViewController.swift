//
//  MoodTagsViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 04/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD

fileprivate let moodTagCellId = "MoodTagCell"
fileprivate let estimatedRowHeight = CGFloat(44.0)

class MoodTagsViewController: MFLViewController {
    
    var presenter : MoodTagsPresenter!
    fileprivate var gradientLayer : CAGradientLayer!
    
    var positiveCellFactory : CellFactory!
    var negativeCellFactory : CellFactory!
    
    @IBOutlet fileprivate var positiveTableView: UITableView!
    @IBOutlet fileprivate var negativeTableView: UITableView!
    
    fileprivate lazy var saveBarButton : UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave(_:)))
    }()
    
    fileprivate lazy var segmentedControl : UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
                NSLocalizedString("Positive", comment: ""),
                NSLocalizedString("Negative", comment: "")
            ])
        
        segmentedControl.addTarget(self, action: #selector(didSelectSegment(_:)), for: .valueChanged)
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightSemibold)], for: .selected)
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)], for: .selected)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.sizeToFit()
        
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = saveBarButton
        navigationItem.titleView = segmentedControl
        
        setUpTableViews()
        setUpGradient()
    }
    
    func setUpTableViews() {
        
        positiveCellFactory = CellFactory(container: positiveTableView)
        negativeCellFactory = CellFactory(container: negativeTableView)
        negativeTableView.isHidden = true
        
        positiveTableView.estimatedRowHeight = estimatedRowHeight
        positiveTableView.rowHeight = UITableViewAutomaticDimension
        negativeTableView.estimatedRowHeight = estimatedRowHeight
        negativeTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = view.bounds
    }
    
    @objc fileprivate func didTapSave(_ sender: Any) {
        presenter.userWantsToSave()
    }
    
    @objc fileprivate func didSelectSegment(_ sender: Any) {
        guard let segmentedControl = sender as? UISegmentedControl else { return }
        
        positiveTableView.isHidden = segmentedControl.selectedSegmentIndex != 0
        negativeTableView.isHidden = !positiveTableView.isHidden
    }
}

//MARK: - UITableViewDataSource
extension MoodTagsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tagCount(forPositive: tableView === positiveTableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: MoodTagCell
        
        if tableView === positiveTableView { cell = positiveCellFactory.dequeueReusableCell(MoodTagCell.self, at: indexPath, in: .mood) }
        else { cell = negativeCellFactory.dequeueReusableCell(MoodTagCell.self, at: indexPath, in: .mood) }
        
        let tag = presenter.tag(at: indexPath.row, forPositive: tableView === positiveTableView)
        
        cell.name = tag.name
        cell.isSelected = tag.isSelected
        
        return cell
    }
}

extension MoodTagsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.userWantsToSelectTag(at: indexPath.row, forPositive: tableView === positiveTableView)
    }
}

//MARK: - MoodTagsPresenterDelegate
extension  MoodTagsViewController : MoodTagsPresenterDelegate {
    
    func moodTagsPresenterWantsToReloadData(_ sender: MoodTagsPresenter) {
        positiveTableView.reloadData()
        negativeTableView.reloadData()
    }
    
    func moodTagsPresenter(_ sender: MoodTagsPresenter, wantsToShowActivity inProgress: Bool) {
        if inProgress { HUD.show(.progress) }
        else { HUD.hide() }
    }
    
    func moodTagsPresenter(_ sender: MoodTagsPresenter, wantsToReloadAt index: Int, forPositive isPositive: Bool) {
        let tableView = isPositive ? positiveTableView : negativeTableView
        
        tableView?.beginUpdates()
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        tableView?.endUpdates()
    }
    
    func moodTagsPresenter(_ sender: MoodTagsPresenter, wantsToShow error: Error) {
        showAlert(for: error)
    }
}

//MARK: - Helper
fileprivate extension MoodTagsViewController {
    
    func setUpGradient() {
        gradientLayer = presenter.emotion.gradientLayer()
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

fileprivate extension Emotion {
    
    func gradientLayer() -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = { () -> [Any] in
            switch self {
            case .happy: return [UIColor.mfl_squash.cgColor, UIColor.mfl_golden.cgColor]
            case .neutral: return [UIColor.mfl_lightBlue.cgColor, UIColor.mfl_sea.cgColor]
            case .sad: return [UIColor.mfl_brownishGrey.cgColor, UIColor.mfl_warmGreyTwo.cgColor]
            }
        }()
        
        return gradientLayer
    }
}
