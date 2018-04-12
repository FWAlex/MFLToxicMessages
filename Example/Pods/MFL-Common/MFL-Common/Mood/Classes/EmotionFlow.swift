//
//  EmotionFlow.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

public protocol EmotionFlowDelegate : class {
    func emotionFlow(_ sender: EmotionFlow, didFinishWithSuccess success: Bool)
}

public class EmotionFlow {
    
    public weak var delegate : EmotionFlowDelegate?
    fileprivate var moodDataStore: MoodDataStore
    fileprivate var pastJournalFlow : PastJournalFlow?
    
    fileprivate var emotionCallback : ((Bool) -> Void)?
    
    fileprivate lazy var flowDependencies : EmotionFlowDependencies = {
        var dependencies = EmotionFlowDependencies()
        dependencies.storyboard = UIStoryboard(name: "Mood", bundle: .mood)
        self.emotion = .sad
        dependencies.navigationController = UINavigationController(navigationBarClass: self.emotion.navBarType, toolbarClass: nil)
        dependencies.moodDataStore = self.moodDataStore
        return dependencies
        
    }()

    fileprivate var emotion : Emotion!
    fileprivate var parentNavController : UINavigationController!
    
    public func start(_ dependencies: HasNavigationController & HasNetworkManager & HasJournalEntryPersistentStore, style: Style) {
    
        self.parentNavController = dependencies.navigationController
        flowDependencies.networkManager = dependencies.networkManager
        flowDependencies.journalEntryPersistentStore = dependencies.journalEntryPersistentStore
        flowDependencies.style = style
        
        moveToHomeEmotionsView()
    }
    
    public init(moodDataStore: MoodDataStore) {
        self.moodDataStore = moodDataStore
    }
}

//MARK: - Navigation
extension EmotionFlow {
    
    func moveToHomeEmotionsView() {
        //FIXME: Check this
        flowDependencies.navigationController = parentNavController
        
        var wireframe = HomeEmotionsFactory.wireframe()
        wireframe.delegate = self
        wireframe.start(flowDependencies)
    }
    
    func moveToEmotionNotePage() {
        var wireframe = EmotionNoteFactory.wireframe()
        wireframe.delegate = self
        flowDependencies.navigationController = UINavigationController(navigationBarClass: self.emotion.navBarType, toolbarClass: nil)
        wireframe.start(flowDependencies, emotion: emotion)
        
        parentNavController.present(flowDependencies.navigationController, animated: true, completion: nil)
    }
    
    func moveToMoodTagsPage(with note: String?) {
        var wireframe = MoodTagsFactory.wireframe()
        wireframe.delegate = self
        wireframe.start(flowDependencies, emotion: emotion, note: note)
    }
    
    func startPastJournalFlow() {
        pastJournalFlow = PastJournalFlow()
        pastJournalFlow?.delegate = self
        flowDependencies.navigationController = self.parentNavController
        pastJournalFlow?.start(flowDependencies)
    }
}

//MARK: - EmotionNoteWireframeDelegate
extension EmotionFlow : EmotionNoteWireframeDelegate {
    
    func emotionNoteWireframe(_ sender: EmotionNoteWireframe, wantsToPresentTagsPageWith note: String?) {
        moveToMoodTagsPage(with: note)
    }
    
    func emotionNoteWireframe(_ sender: EmotionNoteWireframe, didFinishWithSuccess success: Bool) {
        emotionCallback?(success)
        emotionCallback = nil
        parentNavController.dismiss(animated: true, completion: nil)
    }
    
    func emotionNoteWireframeDidCancel(_ sender: EmotionNoteWireframe) {
        emotionCallback?(false)
        emotionCallback = nil
        parentNavController.dismiss(animated: true, completion: nil)
    }
}

extension EmotionFlow: PastJournalFlowDelegate {
    public func pastJournalFlowDidFinish(_ sender: PastJournalFlow) {
        
    }
}

extension EmotionFlow: HomeEmotionsWireframeDelegate {
    public func homeWireframeWantsToPresentPastJournalPage(_ sender: HomeEmotionsWireframe) {
        startPastJournalFlow()
    }

    public func homeWireframe(_ sender: HomeEmotionsWireframe, wantsToPresentEmotionPageWith emotion: Emotion, callback: ((Bool) -> Void)?) {
        self.emotion = emotion
        emotionCallback = callback
        moveToEmotionNotePage()
    }
}

//MARK: - MoodTagsWireframeDelegate
extension EmotionFlow : MoodTagsWireframeDelegate {
    
    func moodTagsWireframeWantsToFinish(_ sender: MoodTagsWireframe) {
        emotionCallback?(true)
        emotionCallback = nil
        parentNavController.dismiss(animated: true, completion: nil)
    }
}

struct EmotionFlowDependencies : HasStoryboard, HasNetworkManager, HasNavigationController, HasMoodDataStore, HasStyle, HasJournalEntryPersistentStore {
    var storyboard: UIStoryboard!
    var navigationController: UINavigationController!
    var networkManager: NetworkManager!
    var moodDataStore: MoodDataStore!
    var style: Style!
    var journalEntryPersistentStore: JournalEntryPersistentStore!
}

public protocol HasMoodDataStore {
    var moodDataStore: MoodDataStore! {get}
}

public protocol MoodDataStore {
    func journalEntryDataStore(networkManager: NetworkManager) -> JournalEntryDateStore
    func moodTagDataStore(networkManager: NetworkManager) -> MoodTagDataStore
}

fileprivate extension Emotion {
    
    var navBarType : UINavigationBar.Type {
        switch self {
        case .happy:    return MFLNavigationBar_Orange.self
        case .neutral:  return MFLNavigationBar_Blue.self
        case .sad:      return MFLNavigationBar_Grey.self
        }
    }
}
