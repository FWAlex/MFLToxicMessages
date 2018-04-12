//
//  LockedForumPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/10/2017.
//Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class LockedForumPresenterImplementation: LockedForumPresenter {
    
    weak var delegate : LockedForumPresenterDelegate?
    fileprivate let interactor: LockedForumInteractor
    fileprivate let wireframe: LockedForumWireframe
    
    
    typealias Dependencies = HasLockedForumWireframe & HasLockedForumInteractor
    init(_ dependencies: Dependencies) {
        interactor = dependencies.interactor
        wireframe = dependencies.wireframe
    }
    
    func userWantsToViewPackages() {
        wireframe.presentPackages()
    }
}
