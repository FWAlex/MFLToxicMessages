//
//  FinkelhorDetailPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 28/11/2017.
//
//

import Foundation

class FinkelhorDetailPresenterImplementation: FinkelhorDetailPresenter {
    
    weak var delegate : FinkelhorDetailPresenterDelegate?
    fileprivate let interactor: FinkelhorDetailInteractor
    fileprivate let wireframe: FinkelhorDetailWireframe
    fileprivate let category: FinkelhorCategory
    
    
    typealias Dependencies = HasFinkelhorDetailWireframe & HasFinkelhorDetailInteractor
    init(_ dependencies: Dependencies, category: FinkelhorCategory) {
        interactor = dependencies.interactor
        wireframe = dependencies.wireframe
        self.category = category
    }
    
    var markdownString : String {
        
        guard let filePath = Bundle.toxicMessages.path(forResource: category.fileName, ofType: "md") else { return "" }
        
        do {
            return try String(contentsOfFile: filePath)
        } catch {
            return ""
        }
    }
    
    func userWantsToViewBehaviour() {
        wireframe.presentBehaviourPage(for: category)
    }
}

fileprivate extension FinkelhorCategory {
    var fileName : String {
        switch self {
        case .traumaticSexualisation: return "Traumatic Sexualisation"
        case .stigmatisation: return "Stigmatisation"
        case .powerlessness: return "Powerlessness"
        case .betrayal: return "Betrayal"
        }
    }
}
