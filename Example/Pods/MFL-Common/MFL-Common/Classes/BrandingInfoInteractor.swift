//
//  BrandingInfoInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 14/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class BrandingInfoInteractorImplementation: BrandingInfoInteractor {
    
    fileprivate let networkManager : NetworkManager
    
    init(_ dependencies: HasNetworkManager) {
        networkManager = dependencies.networkManager
    }
    
    var termsAndConditionsURL : URL {
        return networkManager.urlForTermsAndConditions()
    }
    
    var aboutUsURL : URL {
        return networkManager.urlForAboutUs()
    }
}
