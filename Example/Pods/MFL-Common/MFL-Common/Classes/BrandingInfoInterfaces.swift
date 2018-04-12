//
//  BrandingInfoInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 14/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

public enum BrandingInfoType {
    case termsAndConditions
    case aboutUs
}

//MARK: - Interactor
protocol BrandingInfoInteractor {
    var termsAndConditionsURL : URL { get }
    var aboutUsURL : URL { get }
}

//MARK: - Presenter
protocol BrandingInfoPresenterDelegate : class {
    
}

protocol BrandingInfoPresenter {
    
    weak var delegate : BrandingInfoPresenterDelegate? { get set }
    
    var request : URLRequest? { get }
    
    func userWantsToClose()
}

//MARK: - Wireframe
public protocol BrandingInfoWireframeDelegate : class {
    
}

public protocol BrandingInfoWireframe {
    
    weak var delegate : BrandingInfoWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStyle, type: BrandingInfoType)
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStyle, type: BrandingInfoType, asPush: Bool)
    func close()
}
