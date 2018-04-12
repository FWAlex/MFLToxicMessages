//
//  BrandingInfoFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 14/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasBrandingInfoInteractor {
    var interactor : BrandingInfoInteractor! { get }
}

protocol HasBrandingInfoWireframe {
    var wireframe: BrandingInfoWireframe! { get }
}

public class BrandingInfoFactory {
    
    public class func wireframe() -> BrandingInfoWireframe {
        return BrandingInfoWireframeImplementation()
    }
    
    class func interactor(_ dependencies: BrandingInfoDependencies) -> BrandingInfoInteractor {
        return BrandingInfoInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: BrandingInfoDependencies, type: BrandingInfoType) -> BrandingInfoPresenter {
        return BrandingInfoPresenterImplementation(dependencies, type: type)
    }
}

struct BrandingInfoDependencies : HasBrandingInfoInteractor, HasBrandingInfoWireframe, HasNetworkManager {
    var wireframe: BrandingInfoWireframe!
    var interactor: BrandingInfoInteractor!
    var networkManager : NetworkManager!
}
