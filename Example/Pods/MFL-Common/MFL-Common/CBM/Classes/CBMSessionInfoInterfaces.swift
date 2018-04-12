//
//  CBMSessionInfoInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 08/03/2018.
//
//

import UIKit

enum CBMSessionInfoActionType {
    case `continue`
}

typealias CBMSessionInfoActions = [CBMSessionInfoActionType : Any]

//MARK: - Interactor
protocol CBMSessionInfoInteractor {
    func viewDidAppear()
    func userWantsToStartTrial()
}

//MARK: - Presenter
protocol CBMSessionInfoPresenterDelegate : class {
    func sessionPresenter(_ presenter: CBMSessionInfoPresenter, wantsToPresentActivity inProgress: Bool)
    func sessionPresenter(_ presenter: CBMSessionInfoPresenter, wantsToPresent alert: UIAlertController)
}

protocol CBMSessionInfoPresenter {
    
    weak var delegate : CBMSessionInfoPresenterDelegate? { get set }
    func presentError(error: Error?, callback: (() -> Void)? )
    func showLoadingInProgress()
}

//MARK: - Wireframe
protocol CBMSessionInfoWireframe {
    func viewController(_ dependencies: HasNetworkManager & HasStyle, uuid: String, actions: CBMSessionInfoActions?) -> UIViewController
}
