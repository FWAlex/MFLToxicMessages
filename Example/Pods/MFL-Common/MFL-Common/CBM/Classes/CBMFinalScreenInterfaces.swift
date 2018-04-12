//
//  CBMFinalScreenInterfaces.swift
//  Pods
//
//  Created by Yevgeniy Prokoshev on 19/03/2018.
//
//

import Foundation


enum CBMFinalScreenActionType {
    case startNewSession
}

typealias CBMFinalScreenActions = [CBMFinalScreenActionType : Any]

//MARK: - Interactor

protocol CBMFinalScreenInteractor {
    func viewDidAppear()
    func userWantsToFinishSession()
}

//MARK: - Presenter

protocol CBMFinalScreenPresenterDelegate: class {
    func finlaScreenPresenter(_ presenter: CBMFinalScreenPresenter, wantsToPresentActivity inProgress: Bool)
    func finalScreenPresenter(_ presenter: CBMFinalScreenPresenter, wantsToPresent error: Error)
}

protocol CBMFinalScreenPresenter {
    
    weak var delegate : CBMFinalScreenPresenterDelegate? { get set }
    func showUploadInProgress()
    func showError(error: Error)
}

//MARK: - Wireframe
protocol CBMFinalScreenWireframe {
    func viewController(_ dependencies: HasNetworkManager & HasStyle, session: CBMSession, actions: CBMFinalScreenActions?) -> UIViewController
}
