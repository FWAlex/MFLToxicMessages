//
//  JournalEntryDetailInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

//MARK: - Presenter
protocol JournalEntryDetailPresenter {
    
    var note : String? { get }
    var journalEntryHasNode : Bool { get }
    var journalEntryHasTags : Bool { get }
    var numberOfTags : Int { get }
    func moodTag(at index: Int) -> String?
}

//MARK: - Wireframe
protocol JournalEntryDetailWireframe {
    
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasStyle, journalEntry: JournalEntry)
}
