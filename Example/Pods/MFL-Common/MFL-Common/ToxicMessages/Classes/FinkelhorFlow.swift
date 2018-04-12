//
//  FinkelhorFlow.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 27/11/2017.
//

import Foundation

enum FinkelhorCategory {
    case traumaticSexualisation
    case stigmatisation
    case betrayal
    case powerlessness
}

public class FinkelhorFlow {
    
    typealias Dependencies = HasNavigationController & HasStyle
    
    fileprivate var dependencies : Dependencies!
    
    public init() { /* Empty */ }
    
    public func start(_ dependencies: HasNavigationController & HasStyle) {
        self.dependencies = dependencies
        
        moveToFinkelhorPage()
    }
}

//MARK: - Navigation
extension FinkelhorFlow {
    
    func moveToFinkelhorPage() {
        var wireframe = FinkelhorFactory.wireframe()
        wireframe.delegate = self
        
        let viewController = wireframe.viewController(dependencies)
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func moveToDetailPage(for category: FinkelhorCategory) {
        var wireframe = FinkelhorDetailFactory.wireframe()
        wireframe.delegate = self
        
        let viewController = wireframe.viewController(dependencies, category: category)
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func moveToBehaviourPage(for category: FinkelhorCategory) {
        let viewController = FinkelhorBehaviourFactory.wireframe().viewController(dependencies, category: category)
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
}

//MARK: - FinkelhorWireframeDelegate
extension FinkelhorFlow : FinkelhorWireframeDelegate {
    func finkelhorWireframe(_ sender: FinkelhorWireframe, wantsToPresentDetailPageFor category: FinkelhorCategory) {
        moveToDetailPage(for: category)
    }
}

//MARK: - FinkelhorDetailWireframeDelegate
extension FinkelhorFlow : FinkelhorDetailWireframeDelegate {
    func finkelhorDetailWireframe(_ sender: FinkelhorDetailWireframe, wantsToPresentBehaviourPageFor category: FinkelhorCategory) {
        moveToBehaviourPage(for: category)
    }
}
