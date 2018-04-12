//
//  CBMLoginInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 07/03/2018.
//
//

import UIKit

enum CBMLoginActionType {
    case `continue`
}

typealias CBMLoginActions = [CBMLoginActionType : Any]

//MARK: - Interactor
protocol CBMLoginInteractor {
    func userWantsToLogin(with id: String)
}

//MARK: - Presenter

protocol CBMLoginPresenterDelegate : class {
    func cbmLoginPresenter(_ sender: CBMLoginPresenter, wantsToPresentActivity inProgress: Bool)
    func cbmLoginPresenter(_ sender: CBMLoginPresenter, wantsToPresent error: Error)
}

protocol CBMLoginPresenter {
    
    weak var delegate : CBMLoginPresenterDelegate? { get set }
    
    func show(inProgress: Bool)
    func present(_ error: Error)
}

//MARK: - Wireframe


protocol CBMLoginWireframe {
    func viewController(_ dependencies: HasNetworkManager & HasStyle, actions: CBMLoginActions?) -> UIViewController
}
