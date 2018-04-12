//
//  CopingAndSoothingIntroPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 24/10/2017.
//
//

import Foundation

class CopingAndSoothingIntroPresenterImplementation: CopingAndSoothingIntroPresenter {
    
    weak var delegate : CopingAndSoothingIntroPresenterDelegate?
    fileprivate let interactor: CopingAndSoothingIntroInteractor
    fileprivate let wireframe: CopingAndSoothingIntroWireframe
    
    
    typealias Dependencies = HasCopingAndSoothingIntroWireframe & HasCopingAndSoothingIntroInteractor
    init(_ dependencies: Dependencies) {
        interactor = dependencies.interactor
        wireframe = dependencies.wireframe
    }
    
    func userWantsToTryNow() {
        wireframe.present(detail: .doMore) { [unowned self] in
            self.wireframe.present(detail: .doLess) {
                self.wireframe.presentCopingAndSoothingPage()
            }
        }
    }
}
