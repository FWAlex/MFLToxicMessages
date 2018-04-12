//
//  PastJournalFlow.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 06/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

public protocol PastJournalFlowDelegate : class {
    func pastJournalFlowDidFinish(_ sender: PastJournalFlow)
}

public class PastJournalFlow {
    
    weak var delegate : PastJournalFlowDelegate?
    
    fileprivate lazy var flowDependencies : PastJournalFlowDependencies = {
        var dependencies = PastJournalFlowDependencies()
        dependencies.storyboard = UIStoryboard(name: "Mood", bundle: .mood)
        dependencies.navigationController = UINavigationController(navigationBarClass:  MFLCommon.shared.navigationBarClassLight, toolbarClass: nil)
        return dependencies
    }()
    
    fileprivate var parentNavController : UINavigationController!
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasMoodDataStore & HasStyle) {
        
        self.parentNavController = dependencies.navigationController
        flowDependencies.networkManager = dependencies.networkManager
        flowDependencies.moodDataStore = dependencies.moodDataStore
        flowDependencies.style = dependencies.style
        moveToPastJournalPage()
    }
}

//MARK: - Navigation
extension PastJournalFlow {
    
    func moveToPastJournalPage() {
        var wireframe = PastJournalFactory.wireframe()
        wireframe.delegate = self
        wireframe.start(flowDependencies)
        parentNavController.present(flowDependencies.navigationController, animated: true)
    }
    
    func moveToJournalEntryDetailPage(with journalEntry: JournalEntry) {
        JournalEntryDetailFactory.wireframe().start(flowDependencies, journalEntry: journalEntry)
    }
}

//MARK: - PastJournalWireframeDelegate
extension PastJournalFlow : PastJournalWireframeDelegate {
    
    func pastJournalWireframe(_ sender: PastJournalWireframe, wantsToPresentDetailsFor journalEntry: JournalEntry) {
        moveToJournalEntryDetailPage(with: journalEntry)
    }
    
    func pastJournalWireframeDidFinish(_ sender: PastJournalWireframe) {
        parentNavController.dismiss(animated: true, completion: nil)
        delegate?.pastJournalFlowDidFinish(self)
    }
}


struct PastJournalFlowDependencies : HasStoryboard, HasNetworkManager, HasNavigationController, HasMoodDataStore, HasStyle {
    var storyboard: UIStoryboard!
    var navigationController: UINavigationController!
    var networkManager: NetworkManager!
    var moodDataStore: MoodDataStore!
    var style: Style!
}


