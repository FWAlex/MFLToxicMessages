//
//  PastJournalViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 06/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD

fileprivate let pastEntryCellId = "PastJournalEntryCell"
fileprivate let estimatedRowHeight = CGFloat(28.0)
fileprivate let sectionHeaderHeight = CGFloat(28.0)
fileprivate let sectionHeaderColor = UIColor(r: 243, g: 243, b: 243)
fileprivate let sectionHeaderTitlePadding = CGFloat(16.0)
fileprivate let sectionHeaderTitleColor = UIColor.black.withAlphaComponent(0.4)
fileprivate let tableViewHeaderVertPadding = CGFloat(60.0)
fileprivate let tableViewHeaderHorizPadding = CGFloat(46.0)
fileprivate let tableViewHeaderTitleStyle = TextStyle.bigTitle
fileprivate let tableViewHeaderTitleColor = UIColor.mfl_greyishBrown

class PastJournalViewController: MFLViewController {
    
    var presenter : PastJournalPresenter!
    var cellFactory : CellFactory!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var closeBarButton : UIBarButtonItem = {
        let button = UIButton()
        button.setImage(UIImage.template(named: "close_white", in: .common), for: .normal)
        button.addTarget(self, action: #selector(closeTapped(_:)), for: .touchUpInside)
        button.sizeToFit()
        
        return UIBarButtonItem(customView: button)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = closeBarButton
        
        setUpTableView()
        
        statusBarStyle = .default
        
        presenter.viewDidLoad()
    }
    
    fileprivate func setUpTableView() {
        
        cellFactory = CellFactory(container: tableView)
        
        tableView.estimatedRowHeight = 54
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.tableHeaderView = tableHeaderView()
    }
    
    @objc fileprivate func closeTapped(_ sender: Any) {
        presenter.userWantsToClose()
    }
    
    fileprivate func tableHeaderView() -> UIView {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = tableViewHeaderTitleStyle.attributedString(with: presenter.headerTitle,
                                                                          color: tableViewHeaderTitleColor,
                                                                          alignment: .center)
        let size = label.sizeThatFits(CGSize(width: self.view.width - 2 * tableViewHeaderHorizPadding,
                                             height: CGFloat.infinity))
        
        label.frame.origin.x = (self.view.width - size.width) / 2
        label.frame.origin.y = tableViewHeaderVertPadding
        label.frame.size = size
        
        let view = UIView()
        view.backgroundColor = .white
        view.frame = CGRect(x: 0, y: 0, width: self.view.width, height: label.frame.size.height + 2 * tableViewHeaderVertPadding)
        
        view.addSubview(label)
        
        return view
    }
}

//MARK: - UITableViewDataSource
extension PastJournalViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfEntries(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cellFactory.dequeueReusableCell(PastJournalEntryCell.self, at: indexPath, in: .mood)
        
        cell.set(presenter.journalEntry(at: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.name(for: section)
    }
}

//MARK: - UITableViewDelegate
extension PastJournalViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        var frame = CGRect.zero
        frame.size.width = tableView.width
        frame.size.height = sectionHeaderHeight
        
        view.frame = frame
        view.backgroundColor = sectionHeaderColor
        
        let label = UILabel()
        view.addSubview(label)
        label.textColor = sectionHeaderTitleColor
        label.font = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightBold)
        label.text = presenter.name(for: section)
        label.frame = CGRect.zero
        label.frame.origin.x = sectionHeaderTitlePadding
        label.frame.size.width = view.width - sectionHeaderTitlePadding
        label.frame.size.height = view.height
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.userWantsToSelectEntry(at: indexPath)
    }
}

//MARK: - PastJournalPresenterDelegate
extension PastJournalViewController : PastJournalPresenterDelegate {
    
    func pastJournalPresenterWantsToReladData(_ sender: PastJournalPresenter) {
        tableView.reloadData()
    }
    
    func pastJournalPresenter(_ sender: PastJournalPresenter, wantsToShowActivity inProgress: Bool) {
        if inProgress { HUD.show(.progress) }
        else { HUD.hide() }
    }
    
}

fileprivate extension PastJournalEntryCell {
    
    func set(_ entry: DisplayPastJournalEntry) {
        hasData = entry.hasData
        dateString = entry.dateString
        emotion = entry.emotion
    }
}





