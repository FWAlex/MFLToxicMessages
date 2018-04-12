//
//  FinkelhorInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 27/11/2017.
//
//

import UIKit

//MARK: - Presenter

protocol FinkelhorPresenterDelegate : class {
    
}

protocol FinkelhorPresenter {
    
    weak var delegate : FinkelhorPresenterDelegate? { get set }
    
    var numberOfItems : Int { get }
    func nameForItem(at index: Int) -> String
    func actionForItem(at index: Int) -> (() -> Void)
}

//MARK: - Wireframe

protocol FinkelhorWireframeDelegate : class {
    func finkelhorWireframe(_ sender: FinkelhorWireframe, wantsToPresentDetailPageFor category: FinkelhorCategory)
}

protocol FinkelhorWireframe {
    
    weak var delegate : FinkelhorWireframeDelegate? { get set }
    
    func viewController(_ dependencies: HasStyle) -> UIViewController
    func presentDetailPage(for category: FinkelhorCategory)
}

