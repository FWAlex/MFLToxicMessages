//
//  ToxicMessagesFactory.swift
//  MFLSexualAbuse
//
//  Created by Alex Miculescu on 23/11/2017.
//Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasToxicMessagesWireframe {
    var wireframe: ToxicMessagesWireframe! { get }
}


public class ToxicMessagesFactory {
    
    public class func wireframe() -> ToxicMessagesWireframe {
        return ToxicMessagesWireframeImplementation()
    }
    
    class func presenter(_ dependencies: ToxicMessagesDependencies) -> ToxicMessagesPresenter {
        return ToxicMessagesPresenterImplementation(dependencies)
    }
}

struct ToxicMessagesDependencies: HasToxicMessagesWireframe {
    var wireframe: ToxicMessagesWireframe!
}
