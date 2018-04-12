//
//  ReflectionSpaceFlow.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 03/10/2017.
//

import Foundation

public class ReflectionSpaceFlow {
    
    fileprivate lazy var flowDependencies = ReflectionSpaceFlowDependencies()
    
    public init() {}
    
    public func start(_ dependencies: HasNavigationController & HasStyle) {
        flowDependencies.navigationController = dependencies.navigationController
        flowDependencies.style = dependencies.style
        
        moveToReflectionSpacePage()
    }
}

//MARK: - Navigation
extension ReflectionSpaceFlow {
    func moveToReflectionSpacePage() {
        var wireframe = ReflectionSpaceFactory.wireframe()
        wireframe.delegate = self
        wireframe.start(flowDependencies)
    }
    
    func moveToDetailPage(with item: ReflectionSpaceItemType, and deleteAction: (() -> Void)?) {
        ReflectionSpaceDetailFactory.wireframe().start(flowDependencies, item: item, deleteAction: deleteAction)
    }
}

//MARK: - ReflectionSpaceWireframeDelegate
extension ReflectionSpaceFlow : ReflectionSpaceWireframeDelegate {
    public func reflectionSpaceWireframe(_ sender: ReflectionSpaceWireframe, wantsToPresent item: ReflectionSpaceItemType, with deleteAction: (() -> Void)?) {
        moveToDetailPage(with: item, and: deleteAction)
    }
}

//MARK: - Dependencies
fileprivate struct ReflectionSpaceFlowDependencies : HasStyle, HasNavigationController {
    var style: Style!
    var navigationController: UINavigationController!
}
