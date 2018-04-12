//
//  FinkelhorDetailInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 28/11/2017.
//
//

import UIKit

//MARK: - Interactor


protocol FinkelhorDetailInteractor {
    
}

//MARK: - Presenter

protocol FinkelhorDetailPresenterDelegate : class {
    
}

protocol FinkelhorDetailPresenter {
    
    weak var delegate : FinkelhorDetailPresenterDelegate? { get set }
    
    var markdownString : String { get }
    func userWantsToViewBehaviour()
}

//MARK: - Wireframe

protocol FinkelhorDetailWireframeDelegate : class {
    func finkelhorDetailWireframe(_ sender: FinkelhorDetailWireframe, wantsToPresentBehaviourPageFor category: FinkelhorCategory)
}

protocol FinkelhorDetailWireframe {
    
    weak var delegate : FinkelhorDetailWireframeDelegate? { get set }
    
    func viewController(_ dependencies: HasStyle, category: FinkelhorCategory) -> UIViewController
    
    func presentBehaviourPage(for category: FinkelhorCategory)
}
