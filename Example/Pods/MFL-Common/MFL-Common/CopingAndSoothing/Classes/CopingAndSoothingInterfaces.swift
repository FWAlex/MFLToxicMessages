//
//  CopingAndSoothingInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 23/10/2017.
//
//

import UIKit

//MARK: - Interactor


protocol CopingAndSoothingInteractor {
    func fetchActivities(handler: @escaping (Result<[CSActivity]>) -> Void)
}

//MARK: - Presenter

protocol CopingAndSoothingPresenterDelegate : class {
    func copingAndSoothingPresenter(_ sender: CopingAndSoothingPresenter, wantsToPresentActivity inProgress: Bool)
    func copingAndSoothingPresenter(_ sender: CopingAndSoothingPresenter, wantsToPresent error: Error)
    func copingAndSoothingPresenterWantsToUpdateActivities(_ sender: CopingAndSoothingPresenter)
}

protocol CopingAndSoothingPresenter {
    
    weak var delegate : CopingAndSoothingPresenterDelegate? { get set }
    
    func viewDidAppear()
    func itemsCount(for mode: CopingAndSoothingMode) -> Int
    func bodyForItem(at index: Int, mode: CopingAndSoothingMode) -> String
    func userWantsToEdit(_ mode: CopingAndSoothingMode)
}

//MARK: - Wireframe

protocol CopingAndSoothingWireframeDelegate : class {
    func copingAndSoothingWireframe(_ sender: CopingAndSoothingWireframe, wantsToPresentDetailPageFor mode: CopingAndSoothingMode)
}

protocol CopingAndSoothingWireframe {
    
    weak var delegate : CopingAndSoothingWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStyle & HasNetworkManager, replaceTop: Bool)
    func presentCopingAndSoothingDetailPage(for mode: CopingAndSoothingMode)
}
