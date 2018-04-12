//
//  DateOfBirthWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 07/12/2017.
//
//

import UIKit

class DateOfBirthWireframeImplementation : DateOfBirthWireframe {
    
    weak var delegate : DateOfBirthWireframeDelegate?
    private lazy var storyboard : UIStoryboard = { return UIStoryboard(name: "Onboarding", bundle: .common ) }()
    
    func viewController(_ dependencies: HasStyle, copy: DateOfBirthCopy) -> UIViewController {
        var moduleDependencies = DateOfBirthDependencies()
        moduleDependencies.wireframe = self
        
        var presenter = DateOfBirthFactory.presenter(moduleDependencies, copy: copy)
        let viewController: DateOfBirthViewController = storyboard.viewController()
        
        viewController.style = dependencies.style
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        return viewController
    }
    
    func `continue`(with registerData: RegisterData) {
        delegate?.dateOfBirthWireframe(self, wantsToContinueWith: registerData)
    }
}


