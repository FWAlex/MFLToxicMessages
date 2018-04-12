//
//  ReflectionSpaceDetailWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 06/10/2017.
//
//

import UIKit

class ReflectionSpaceDetailWireframeImplementation : ReflectionSpaceDetailWireframe {
    
    weak var delegate : ReflectionSpaceDetailWireframeDelegate?
    
    fileprivate lazy var storyboard : UIStoryboard = { return UIStoryboard(name: "ReflectionSpace", bundle: .reflectionSpace) }()
    fileprivate var navigationController : UINavigationController!
    
    fileprivate var deleteAction : (() -> Void)?
    
    func start(_ dependencies: HasNavigationController & HasStyle, item: ReflectionSpaceItemType, deleteAction: (() -> Void)?) {
        navigationController = dependencies.navigationController
        self.deleteAction = deleteAction
        
        var moduleDependencies = ReflectionSpaceDetailDependencies()
        moduleDependencies.wireframe = self
        moduleDependencies.interactor = ReflectionSpaceDetailFactory.interactor()
        
        var presenter = ReflectionSpaceDetailFactory.presenter(moduleDependencies, item: item)
        let viewController: ReflectionSpaceDetailViewController = storyboard.viewController()
        viewController.style = dependencies.style
        
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        let embededNavCtrl = UINavigationController(navigationBarClass: MFLCommon.shared.navigationBarClassDark, toolbarClass: nil)
        embededNavCtrl.viewControllers = [viewController]
        navigationController.present(embededNavCtrl, animated: true, completion: nil)
    }
    
    func close() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func delete() {
        navigationController.dismiss(animated: true) { [weak self] in
            self?.deleteAction?()
        }
    }
}


