//
//  SuicidalHelpFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

public class NightmaresTraumaHelpFactory {
    
    public class func wireframe() -> NightmaresTraumaHelpWireframe {
        return NightmaresTraumaHelpWireframeImplementation()
    }
    
    class func presenter(wireframe: NightmaresTraumaHelpWireframe) -> NightmaresTraumaHelpPresenter {
        return NightmaresTraumaHelpPresenterImplementation(wireframe: wireframe)
    }
}
