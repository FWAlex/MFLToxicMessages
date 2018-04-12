//
//  CBMLoginInteractor.swift
//  Pods
//
//  Created by Alex Miculescu on 07/03/2018.
//
//

import Foundation

class CBMLoginInteractorImplementation: CBMLoginInteractor {
 
    fileprivate let presenter: CBMLoginPresenter
    fileprivate let cbmDataStore : CBMDataStore
    fileprivate let actions : CBMLoginActions?
    
    
    init(_ dependencies: HasCBMLoginPresenter & HasCBMDataStore, actions: CBMLoginActions?) {
        presenter = dependencies.cbmLoginPresenter
        cbmDataStore = dependencies.cbmDataStore
        self.actions = actions
    }
    
    //MARK: - Exposed
    func userWantsToLogin(with id: String) {
        presenter.show(inProgress: true)
        cbmDataStore.fetchCBMSessions(for: id) { [unowned self] result in
            
            self.presenter.show(inProgress: false)
            switch result {
            case .success(_): self.continue(using: id)
            case .failure(let error): self.presenter.present(error)
            }
        }
    }
}

//MARK: - Helper
private extension CBMLoginInteractorImplementation {
    
    func `continue`(using uuid: String) {
        guard let actions = actions, let action = actions[.continue] else { return }
        guard let continueAction = action as? (String) -> Void else {
            preconditionFailure("The \".continue\" action does not have the expected type: (String) -> Void")
            return
        }
        
        continueAction(uuid)
    }
}
