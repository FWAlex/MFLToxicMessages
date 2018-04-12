//
//  CBMPerformSessionInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 13/03/2018.
//
//

import UIKit

enum CBMPerformSessionActionType {
    case sessionFinished
}

typealias CBMPerformSessionActions = [CBMPerformSessionActionType : Any]

//MARK: - Interactor
protocol CBMPerformSessionInteractor {
    func viewDidAppear()
    func userDidFocus()
    func userDidSeeImages()
    func userDidSeeProbes()
    func userDidSeeMessage()
    
    func userDidSelectProbe_E()
    func userDidSelectProbe_F()
}

//MARK: - Presenter
protocol CBMPerformSessionPresenterDelegate : class {
    func performSessionPresenterWantsToPresentFocus(_ sender: CBMPerformSessionPresenter)
    func performSessionPresenter(_ sender: CBMPerformSessionPresenter, wantsToSetInputEnabled isEnabled: Bool)
    
    func performSessionPresenter(_ sender: CBMPerformSessionPresenter, wantsToPresentImages images: CBMPerformSessionImagesDisplay)
    func performSessionPresenterWantsToHideImages(_ sender: CBMPerformSessionPresenter)
    
    func performSessionPresenter(_ sender: CBMPerformSessionPresenter, wantsToPresentProbes images: CBMPerformSessionImagesDisplay)
    func performSessionPresenterWantsToHideProbes(_ sender: CBMPerformSessionPresenter)
    
    func performSessionPresenter(_ sender: CBMPerformSessionPresenter, wantsToShowMessage message: String)
    func performSessionPresenterWantsToHideMessage(_ sender: CBMPerformSessionPresenter)
}

protocol CBMPerformSessionPresenter {
    
    weak var delegate : CBMPerformSessionPresenterDelegate? { get set }
    
    func focus()
    func enableInput()
    func disableInput()
    
    func showImages(for trial: CBMTrial)
    func hideImages()
    
    func showProbe(type: ProbeType, for trial: CBMTrial)
    func hideProbes()
    
    func showBadSelection()
    func showFailureToSelect()
    
    func hideMessage()
}

//MARK: - Wireframe
protocol CBMPerformSessionWireframe {
    func viewController(_ dependencies: HasNetworkManager & HasStyle, session: CBMSession, actions: CBMPerformSessionActions?) -> UIViewController
}
