//
//  BrandingInfoPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 14/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class BrandingInfoPresenterImplementation: BrandingInfoPresenter {
    
    weak var delegate : BrandingInfoPresenterDelegate?
    fileprivate let interactor: BrandingInfoInteractor
    fileprivate let wireframe: BrandingInfoWireframe
    fileprivate let type : BrandingInfoType
    
    typealias Dependencies = HasBrandingInfoWireframe & HasBrandingInfoInteractor
    init(_ dependencies: Dependencies, type: BrandingInfoType) {
        interactor = dependencies.interactor
        wireframe = dependencies.wireframe
        self.type = type
    }
    
    //MARK: - Exposed
    var request : URLRequest? {

        switch type {
        case .termsAndConditions: return URLRequest(url: interactor.termsAndConditionsURL)
        case .aboutUs: return URLRequest(url: interactor.aboutUsURL)
        }
    }
    
    func userWantsToClose() {
        wireframe.close()
    }
}
