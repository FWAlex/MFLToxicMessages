//
//  LockedForumInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/10/2017.
//Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

//MARK: - Interactor


protocol LockedForumInteractor {
    
}

//MARK: - Presenter

protocol LockedForumPresenterDelegate : class {
    
}

protocol LockedForumPresenter {
    
    weak var delegate : LockedForumPresenterDelegate? { get set }
    
    func userWantsToViewPackages()
}

//MARK: - Wireframe

protocol LockedForumWireframeDelegate : class {
    func lockedForumWireframeWantsToPresentPackagesPage(_ sender: LockedForumWireframe)
}

protocol LockedForumWireframe {
    
    weak var delegate : LockedForumWireframeDelegate? { get set }
    
    func start(_ dependencies: HasStoryboard & HasNavigationController & HasStoryboard & HasStyle, asPush: Bool)
    
    func presentPackages()
}
