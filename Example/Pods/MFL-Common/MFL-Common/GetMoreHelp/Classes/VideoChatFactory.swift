//
//  VideoChatFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 14/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasVideoChatInteractor {
    var videoChatInteractor : VideoChatInteractor! { get }
}

protocol HasVideoChatWireframe {
    var videoChatWireframe : VideoChatWireframe! { get }
}

class VideoChatFactory {
    
    class func wireframe() -> VideoChatWireframe {
        return VideoChatWireframeImplementation()
    }
    
    class func interactor() -> VideoChatInteractor {
        return VideoChatInteractorImplementation()
    }
    
    class func presenter(_ dependencies: VideoChatDependencies) -> VideoChatPresenter {
        return VideoChatPresenterImplementation(dependencies)
    }
}

struct VideoChatDependencies : HasVideoChatInteractor, HasVideoChatWireframe, HasVideoSessionManager, HasSession {
    
    var videoChatWireframe: VideoChatWireframe!
    var videoChatInteractor: VideoChatInteractor!
    var videoSessionManager: VideoSessionManager!
    var session: Session!
}
