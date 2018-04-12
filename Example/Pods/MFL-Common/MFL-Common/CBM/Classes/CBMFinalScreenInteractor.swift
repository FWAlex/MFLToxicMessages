//
//  CBMFinalScreenInteractor.swift
//  Pods
//
//  Created by Yevgeniy Prokoshev on 19/03/2018.
//
//

import Foundation

class CBMFinalScreenInteractorImplementation: CBMFinalScreenInteractor {
    
    fileprivate let presenter : CBMFinalScreenPresenter
    fileprivate let networkManager : NetworkManager
    fileprivate let cbmStore : CBMDataStore

    
    fileprivate let actions : CBMFinalScreenActions?
    fileprivate var session : CBMSession?
    
    init(_ dependencies: CBMFinalScreenDependencies, session: CBMSession, actions: CBMFinalScreenActions?) {
        self.presenter = dependencies.presenter
        self.networkManager = dependencies.networkManager
        self.session = session
        self.actions = actions
        self.cbmStore = dependencies.cbmDataStore
    }
    
    func userWantsToFinishSession() {
        guard let session = session else { return }
        presenter.showUploadInProgress()
        //Upload is too fast , let's give a bit of a room for loading state
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.networkManager.sendCBMResultsFor(session: session) {[weak self] (result) in
                switch result {
                case .success(_):
                    self?.finish()
                case .failure(let error):
                    self?.presenter.showError(error:error)
                }
            }
        }
    }
    
    func viewDidAppear() {}
}

private extension CBMFinalScreenInteractorImplementation {
    func finish() {
        if let session = session {
            self.cbmStore.finishSession(session.id)
        }
        
        guard let action = actions?[.startNewSession] as? (() -> Void) else { return }
        action()
    }
}
