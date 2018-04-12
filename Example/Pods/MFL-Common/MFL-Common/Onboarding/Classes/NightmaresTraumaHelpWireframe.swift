//
//  SuicidalHelpWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import MFL_Common

class NightmaresTraumaHelpWireframeImplementation : NightmaresTraumaHelpWireframe {
    
    fileprivate var navigationController : UINavigationController!
    fileprivate var storyboard : UIStoryboard = { return UIStoryboard(name: "Onboarding", bundle: .common) }()
    
    func start(_ dependencies: HasNavigationController & HasStyle) {
        
        self.navigationController = dependencies.navigationController
        
        let presenter = NightmaresTraumaHelpFactory.presenter(wireframe: self)
        
        let viewController: NightmaresTraumaHelpViewController = storyboard.viewController()
        
        viewController.style = dependencies.style
        viewController.presenter = presenter
        viewController.title = NSLocalizedString("Support", comment: "")
        
        let enbedingNavCtrl = UINavigationController(navigationBarClass: MFLCommon.shared.navigationBarClassLight, toolbarClass: nil)
        enbedingNavCtrl.viewControllers = [viewController]
        navigationController.present(enbedingNavCtrl, animated: true, completion: nil)
    }
    
    func openLinkInBrowser(_ urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        UIApplication.shared.open(url,
                                  options: [:],
                                  completionHandler: nil)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}


