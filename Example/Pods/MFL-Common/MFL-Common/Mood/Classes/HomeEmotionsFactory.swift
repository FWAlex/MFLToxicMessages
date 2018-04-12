//
//  HomeEmotionsFactory.swift
//  Pods
//
//  Created by Marc Blasi on 01/09/2017.
//
//

import Foundation

public protocol HasHomeEmotionsInteractor {
    var HomeEmotionsInteractor : HomeEmotionsInteractor! { get }
}

public protocol HasHomeEmotionsWireframe {
    var HomeEmotionsWireframe: HomeEmotionsWireframe! { get }
}


public class HomeEmotionsFactory {
    
    class func wireframe() -> HomeEmotionsWireframe {
        return HomeEmotionsWireframeImplementation()
    }
    
    class func interactor(_ dependencies: HomeEmotionsDependencies) -> HomeEmotionsInteractor {
        return HomeEmotionsInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: HomeEmotionsDependencies) -> HomeEmotionsPresenter {
        return HomeEmotionsPresenterImplementation(dependencies)
    }
}

struct HomeEmotionsDependencies : HasHomeEmotionsWireframe, HasHomeEmotionsInteractor, HasJournalEntryDataStore {
    var HomeEmotionsInteractor: HomeEmotionsInteractor!

    var HomeEmotionsWireframe: HomeEmotionsWireframe!
    var journalEntryDataStore: JournalEntryDateStore!
}
