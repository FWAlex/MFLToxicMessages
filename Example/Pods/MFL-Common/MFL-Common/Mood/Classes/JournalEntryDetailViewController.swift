//
//  JournalEntryDetailViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class JournalEntryDetailViewController: MFLViewController {
    
    var presenter : JournalEntryDetailPresenter!
    var cellFactory : CellFactory!
    var style : Style!
    @IBOutlet fileprivate var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarStyle = .default
        
        setUpTableView()
    }
    
    fileprivate func setUpTableView() {
        cellFactory = CellFactory(container: tableView)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

//MARK: - UITableViewDataSource
extension JournalEntryDetailViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return presenter.journalEntryHasNode ? 1 : 0
        case 1: return presenter.numberOfTags
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = cellFactory.dequeueReusableCell(JournalEntryDetailNoteCell.self, at: indexPath, in: .mood)
            cell.noteText = presenter.note
            cell.style = style
            return cell
        }
        else {
            let cell = cellFactory.dequeueReusableCell(JournalEntryDetailTagCell.self, at: indexPath, in: .mood)
            cell.style = style
            cell.moodTag = presenter.moodTag(at: indexPath.row)
            return cell
        }
    }
}
