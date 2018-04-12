//
//  SuicidalHelpInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import MFL_Common

//MARK: - Presenter
public protocol NightmaresTraumaHelpPresenter {
    
    func userWantsToViewCounsellingApp()
    func userWantsToCancel()
}

//MARK: - Wireframe
public protocol NightmaresTraumaHelpWireframe {
    
    func start(_ dependencies: HasNavigationController & HasStyle)
    
    func openLinkInBrowser(_ urlString: String)
    func dismiss()
}
