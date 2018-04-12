//
//  FilePresenter.swift
//  Pods
//
//  Created by Marc Blasi on 04/10/2017.
//
//

import Foundation

class StepDetailPresenterImplementation: StepDetailPresenter {
    
    weak var delegate : StepDetailPresenterDelegate?
    fileprivate let interactor: StepDetailInteractor
    fileprivate let wireframe: StepDetailWireframe
    var step: StepPage
    
    typealias Dependencies = HasStepDetailWireframe & HasStepDetailInteractor
    init(_ dependencies: Dependencies, step: StepPage) {
        interactor = dependencies.interactor
        wireframe = dependencies.wireframe
        self.step = step
    }
}
