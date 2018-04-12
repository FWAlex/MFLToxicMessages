//
//  PastJournalPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 06/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class PastJournalPresenterImplementation: PastJournalPresenter {
    
    weak var delegate : PastJournalPresenterDelegate?
    fileprivate let interactor: PastJournalInteractor
    fileprivate let wireframe: PastJournalWireframe
    fileprivate var sections = [String : [JournalEntry]]()
    fileprivate var sectionKeys = [String]()
    
    fileprivate lazy var sectionKeyDateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        return dateFormatter
    }()
    
    typealias Dependencies = HasPastJournalWireframe & HasPastJournalInteractor
    init(_ dependencies: Dependencies) {
        interactor = dependencies.pastJournalInteractor
        wireframe = dependencies.pastJournalWireframe
    }
    
    func viewDidLoad() {
        
        delegate?.pastJournalPresenter(self, wantsToShowActivity: true)
        
        interactor.fetchJournalEntries() { [unowned self] pastEntries, error in
            
            self.extractSectionsAndKeys(form: pastEntries)
            self.delegate?.pastJournalPresenter(self, wantsToShowActivity: false)
            self.delegate?.pastJournalPresenterWantsToReladData(self)
        }
    }
    
    var headerTitle : String {
        return NSLocalizedString("This is how you have been feeling", comment: "")
    }
    
    var sectionsCount: Int {
        return sections.count
    }
    
    func numberOfEntries(in section: Int) -> Int {
        return sections[sectionKeys[section]]?.count ?? 0
    }
    
    func journalEntry(at indexPath: IndexPath) -> DisplayPastJournalEntry {
        return DisplayPastJournalEntry(journalEntry(at: indexPath))
    }
    
    func name(for section: Int) -> String {
        return sectionKeys[section].uppercased()
    }
    
    func userWantsToSelectEntry(at indexPath: IndexPath) {
        let entry: JournalEntry = journalEntry(at: indexPath)
        
        if entry.hasData {
            wireframe.presentDetails(for: entry)
        }
    }
    
    fileprivate func extractSectionsAndKeys(form entries: [JournalEntry]) {
        
        let sortedEntries = entries.sorted { $0.dateCreated > $1.dateCreated }
        
        sections = [String : [JournalEntry]]()
        sectionKeys = [String]()
        
        for journalEntry in sortedEntries {
            
            let key = sectionKeyDateFormatter.string(from: journalEntry.dateCreated)
            
            if !sectionKeys.contains(key) { sectionKeys.insert(key, at: 0) }
            
            if var sectionElements = sections[key] {
                sectionElements.append(journalEntry)
                sections[key] = sectionElements
            }
            else { sections[key] = [journalEntry] }
        }
    }
    
    fileprivate func journalEntry(at indexPath: IndexPath) -> JournalEntry {
        let sectionKey = sectionKeys[indexPath.section]
        let elements = sections[sectionKey]!
        return elements[indexPath.row]
    }
    
    func userWantsToClose() {
        wireframe.close()
    }
}

fileprivate extension JournalEntry {
    
    var hasData : Bool {
        let tagsCount = moodTags?.count ?? 0

        return tagsCount != 0 || !mfl_nilOrEmpty(reason)
    }
}

fileprivate let entryDateFormatter : DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy"
    
    return dateFormatter
}()

fileprivate extension DisplayPastJournalEntry {
    
    init(_ journalEntry: JournalEntry) {
        emotion = journalEntry.emotion
        dateString = entryDateFormatter.string(from: journalEntry.dateCreated)
        hasData = journalEntry.hasData
    }
}
