//
//  LockedForumFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 24/10/2017.
//Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasLockedForumInteractor {
    var interactor : LockedForumInteractor! { get }
}

protocol HasLockedForumWireframe {
    var wireframe: LockedForumWireframe! { get }
}


class LockedForumFactory {
    
    class func wireframe() -> LockedForumWireframe {
        return LockedForumWireframeImplementation()
    }
    
    class func interactor() -> LockedForumInteractor {
        return LockedForumInteractorImplementation()
    }
    
    class func presenter(_ dependencies: LockedForumDependencies) -> LockedForumPresenter {
        return LockedForumPresenterImplementation(dependencies)
    }
}

struct LockedForumDependencies : HasLockedForumInteractor, HasLockedForumWireframe {
    var wireframe: LockedForumWireframe!
    var interactor: LockedForumInteractor!
}
