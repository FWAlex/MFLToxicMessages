//
//  TherapistChatFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 03/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasTherapistChatWireframe {
    var therapistChatWireframe : TherapistChatWireframe! { get }
}

protocol HasTherapistChatInteractor {
    var therapistChatInteractor : TherapistChatInteractor! { get }
}

class TherapistChatFactory {
    
    class func wireframe() -> TherapistChatWireframe {
        return TherapistChatWireframeImplementation()
    }
    
    class func interactor(_ dependencies: TherapistChatDependencies) -> TherapistChatInteractor {
        return TherapistChatInteractorImplementation(dependencies)
    }
    
    class func presenter( _ dependencies: inout TherapistChatDependencies) -> TherapistChatPresenter {
        let presenter = TherapistChatPresenterImplementation(dependencies)
        dependencies.therapistChatInteractor.delegate = presenter
        
        return presenter
    }
}

struct TherapistChatDependencies : HasTherapistChatWireframe, HasTherapistChatInteractor, HasUserDataStore, HasRTCManager, HasQuestionnaireDataStore {
    var therapistChatWireframe: TherapistChatWireframe!
    var therapistChatInteractor: TherapistChatInteractor!
    var userDataStore: UserDataStore!
    var rtcManager: RTCManager!
    var questionnaireDataStore: QuestionnaireDataStore!
}
