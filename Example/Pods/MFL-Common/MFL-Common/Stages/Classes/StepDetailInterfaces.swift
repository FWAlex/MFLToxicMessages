//
//  FileInterfaces.swift
//  Pods
//
//  Created by Marc Blasi on 04/10/2017.
//
//

import UIKit

//MARK: - Interactor


protocol StepDetailInteractor {
   
}

//MARK: - Presenter

protocol StepDetailPresenterDelegate : class {
    
}

protocol StepDetailPresenter {
    var step: StepPage { get }
    weak var delegate : StepDetailPresenterDelegate? { get set }
}

//MARK: - Wireframe

protocol StepDetailWireframeDelegate : class {
    
}

protocol StepDetailWireframe {
    
    weak var delegate : StepDetailWireframeDelegate? { get set }
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasStageDataStore & HasStyle, step: StepPage)
}
