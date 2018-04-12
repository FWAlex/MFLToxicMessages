//
//  FinkelhorBehaviourInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 05/12/2017.
//
//

import UIKit

//MARK: - Interactor


protocol FinkelhorBehaviourInteractor {
    func getBehaviours(for category: FinkelhorCategory) -> [FinkelhorBehaviour]
    func save(_ behaviour: FinkelhorBehaviour)
}

//MARK: - Presenter

protocol FinkelhorBehaviourPresenterDelegate : class {
    
}

protocol FinkelhorBehaviourPresenter {
    
    weak var delegate : FinkelhorBehaviourPresenterDelegate? { get set }
    
    func viewDidLoad()
    
    var numberOfSections : Int { get }
    func numberOfItems(in section: Int) -> Int
    func sectionName(at index: Int) -> String
    func behaviour(at indexPath: IndexPath) -> FinkelhorBehaviourDisplay
    func set(_ selection: FinkelhorBehaviourSelectionDisplay, forItemAt indexPath: IndexPath)
}

//MARK: - Wireframe

protocol FinkelhorBehaviourWireframeDelegate : class {
    
}

protocol FinkelhorBehaviourWireframe {
    
    weak var delegate : FinkelhorBehaviourWireframeDelegate? { get set }
    
    func viewController(_ dependencies: HasStyle, category: FinkelhorCategory) -> UIViewController
}
