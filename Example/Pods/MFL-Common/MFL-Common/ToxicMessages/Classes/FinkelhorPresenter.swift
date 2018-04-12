//
//  FinkelhorPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 27/11/2017.
//
//

import Foundation

class FinkelhorPresenterImplementation: FinkelhorPresenter {
    
    weak var delegate : FinkelhorPresenterDelegate?
    fileprivate let wireframe: FinkelhorWireframe
    
    typealias Dependencies = HasFinkelhorWireframe
    init(_ dependencies: Dependencies) {
        wireframe = dependencies.wireframe
    }
    
    var numberOfItems : Int {
        return FinkelhorCategory.count
    }
    
    func nameForItem(at index: Int) -> String {
        return FinkelhorCategory.allValues[index].name
    }
    
    func actionForItem(at index: Int) -> (() -> Void) {
        let item = FinkelhorCategory.allValues[index]
        return { [unowned self] in self.wireframe.presentDetailPage(for: item) }
    }
}

fileprivate extension FinkelhorCategory {
    
    var name : String {
        switch self {
        case .traumaticSexualisation: return NSLocalizedString("Traumatic Sexualisation", comment: "")
        case .stigmatisation: return NSLocalizedString("Stigmatisation", comment: "")
        case .betrayal: return NSLocalizedString("Betrayal", comment: "")
        case .powerlessness: return NSLocalizedString("Powerlessness", comment: "")
        }
    }
    
    static var allValues : [FinkelhorCategory] {
        return [self.traumaticSexualisation, .stigmatisation, .betrayal, .powerlessness]
    }
    
    static var count : Int {
        return allValues.count
    }
}
