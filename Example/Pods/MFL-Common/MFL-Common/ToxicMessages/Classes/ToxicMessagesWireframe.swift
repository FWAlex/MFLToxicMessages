//
//  ToxicMessagesWireframe.swift
//  MFLSexualAbuse
//
//  Created by Alex Miculescu on 23/11/2017.
//Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class ToxicMessagesWireframeImplementation : ToxicMessagesWireframe {
    
    weak var delegate : ToxicMessagesWireframeDelegate?
    private lazy var storyboard : UIStoryboard = { return UIStoryboard(name: "ToxicMessages", bundle: .toxicMessages) }()
    
    func setUp(_ dependencies: HasStyle) -> UIViewController {
        var moduleDependencies = ToxicMessagesDependencies()
        moduleDependencies.wireframe = self
        
        var presenter = ToxicMessagesFactory.presenter(moduleDependencies)
        let viewController: ToxicMessagesViewController = storyboard.viewController()
        viewController.style = dependencies.style
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        return viewController
    }
}


