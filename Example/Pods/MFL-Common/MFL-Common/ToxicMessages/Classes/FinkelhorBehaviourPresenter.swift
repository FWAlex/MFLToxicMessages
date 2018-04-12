//
//  FinkelhorBehaviourPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 05/12/2017.
//
//

import Foundation

class FinkelhorBehaviourPresenterImplementation: FinkelhorBehaviourPresenter {
    
    weak var delegate : FinkelhorBehaviourPresenterDelegate?
    fileprivate let interactor: FinkelhorBehaviourInteractor
    fileprivate let wireframe: FinkelhorBehaviourWireframe
    fileprivate let category : FinkelhorCategory
    fileprivate var data = [String : [FinkelhorBehaviour]]()
    fileprivate var sections = [String]()
    
    typealias Dependencies = HasFinkelhorBehaviourWireframe & HasFinkelhorBehaviourInteractor
    init(_ dependencies: Dependencies, category: FinkelhorCategory) {
        interactor = dependencies.interactor
        wireframe = dependencies.wireframe
        self.category = category
    }
    
    func viewDidLoad() {
        let behaviours = interactor.getBehaviours(for: category)
        for behaviour in behaviours {
            if data[behaviour.section] == nil { data[behaviour.section] = [FinkelhorBehaviour]() }
            data[behaviour.section]?.append(behaviour)
            if !sections.contains(behaviour.section) { sections.append(behaviour.section) }
        }
    }
    
    var numberOfSections : Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        return data[sections[section]]!.count
    }
    
    func sectionName(at index: Int) -> String {
        return sections[index]
    }
    
    func behaviour(at indexPath: IndexPath) -> FinkelhorBehaviourDisplay {
        return FinkelhorBehaviourDisplay(data[sections[indexPath.section]]![indexPath.row])
    }
    
    func set(_ selection: FinkelhorBehaviourSelectionDisplay, forItemAt indexPath: IndexPath) {
        var behaviour = data[sections[indexPath.section]]![indexPath.row]
        behaviour.selection = FinkelhorBehaviourSelection(selection)
        interactor.save(behaviour)
    }
}

fileprivate extension FinkelhorBehaviourDisplay {
    init(_ behaviour: FinkelhorBehaviour) {
        self.text = behaviour.text
        self.selection = behaviour.selection.display
    }
}

fileprivate extension FinkelhorBehaviourSelection {
    
    init(_ selectionDisplay: FinkelhorBehaviourSelectionDisplay) {
        switch selectionDisplay {
        case .none: self = .none
        case .now: self = .now
        case .past: self = .past
        }
    }
    
    var display : FinkelhorBehaviourSelectionDisplay {
        switch self {
        case .none: return .none
        case .now: return .now
        case .past: return .past
        }
    }
}
