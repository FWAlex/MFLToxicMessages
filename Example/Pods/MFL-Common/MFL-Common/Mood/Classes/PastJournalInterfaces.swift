//
//  PastJournalInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 06/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

//MARK: - Interactor


protocol PastJournalInteractor {
    func fetchJournalEntries(handler: @escaping ([JournalEntry], Error?) -> Void)
}

//MARK: - Presenter
protocol PastJournalPresenterDelegate : class {
    func pastJournalPresenter(_ sender: PastJournalPresenter, wantsToShowActivity inProgress: Bool)
    func pastJournalPresenterWantsToReladData(_ sender: PastJournalPresenter)
}

protocol PastJournalPresenter {
    
    weak var delegate : PastJournalPresenterDelegate? { get set }

    func viewDidLoad()

    var headerTitle : String { get }
    var sectionsCount : Int { get }
    func numberOfEntries(in section: Int) -> Int
    func journalEntry(at indexPath: IndexPath) -> DisplayPastJournalEntry
    func name(for section: Int) -> String
    
    func userWantsToSelectEntry(at indexPath: IndexPath)
    
    func userWantsToClose()
}

//MARK: - Wireframe
protocol PastJournalWireframeDelegate : class {
    func pastJournalWireframeDidFinish(_ sender: PastJournalWireframe)
    func pastJournalWireframe(_ sender: PastJournalWireframe, wantsToPresentDetailsFor journalEntry: JournalEntry)
}

protocol PastJournalWireframe {
    
    weak var delegate : PastJournalWireframeDelegate? { get set }
    
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasNetworkManager & HasMoodDataStore)
    
    func presentDetails(for journalEntry: JournalEntry)
    func close()
}
