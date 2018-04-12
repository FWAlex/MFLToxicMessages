//
//  CopingAndSoothingIntroInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 24/10/2017.
//
//

import UIKit

//MARK: - Interactor


protocol CopingAndSoothingIntroInteractor {
    
}

//MARK: - Presenter

protocol CopingAndSoothingIntroPresenterDelegate : class {
    
}

protocol CopingAndSoothingIntroPresenter {
    
    weak var delegate : CopingAndSoothingIntroPresenterDelegate? { get set }
    
    func userWantsToTryNow()
}

//MARK: - Wireframe

protocol CopingAndSoothingIntroWireframeDelegate : class {
    func copingAndSoothingIntroWireframe(_ sender: CopingAndSoothingIntroWireframe,
                                         wantsToPresentDetail mode: CopingAndSoothingMode,
                                         completion: @escaping () -> Void)
    func copingAndSoothingIntroWireframeWantsToPresentCopingAndSoothingPage(_ sender: CopingAndSoothingIntroWireframe)
}

protocol CopingAndSoothingIntroWireframe {
    
    weak var delegate : CopingAndSoothingIntroWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStyle)
    
    func present(detail mode: CopingAndSoothingMode, completion: @escaping () -> Void)
    func presentCopingAndSoothingPage()
}
