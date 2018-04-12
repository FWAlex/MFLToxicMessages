//
//  JournalEntryDetailWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class JournalEntryDetailWireframeImplementation : JournalEntryDetailWireframe {
    
    fileprivate lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        return dateFormatter
    }()
    
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasStyle, journalEntry: JournalEntry) {
        
        let presenter = JournalEntryDetailFactory.presenter(journalEntry: journalEntry)
        let viewController: JournalEntryDetailViewController = dependencies.storyboard.viewController()
        viewController.presenter = presenter
        viewController.title = dateFormatter.string(from: journalEntry.dateCreated)
        viewController.style = dependencies.style
        
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
}


