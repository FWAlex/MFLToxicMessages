//
//  ReflectionSpaceDetailInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 06/10/2017.
//
//

import UIKit

//MARK: - Interactor


protocol ReflectionSpaceDetailInteractor {
    
}

//MARK: - Presenter

protocol ReflectionSpaceDetailPresenterDelegate : class {
    func reflectionSpaceDetailPresenter(_ sender: ReflectionSpaceDetailPresenter, wantsToShow alert: UIAlertController)
}

protocol ReflectionSpaceDetailPresenter {
    
    weak var delegate : ReflectionSpaceDetailPresenterDelegate? { get set }
    
    var displayItem : ReflectionSpaceDetailDisplayItem { get }
    func userWantsToClose()
    func userWantsToDelete()
}

//MARK: - Wireframe

protocol ReflectionSpaceDetailWireframeDelegate : class {
    
}

protocol ReflectionSpaceDetailWireframe {
    
    weak var delegate : ReflectionSpaceDetailWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStyle, item: ReflectionSpaceItemType, deleteAction: (() -> Void)?)
    func close()
    func delete()
}
