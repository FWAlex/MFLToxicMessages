//
//  CopingAndSoothingDetailWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 26/10/2017.
//
//

import UIKit

class CopingAndSoothingDetailWireframeImplementation : CopingAndSoothingDetailWireframe {
    
    weak var delegate : CopingAndSoothingDetailWireframeDelegate?
    private let storyboard = UIStoryboard(name: "CopingAndSoothing", bundle: .copingAndSoothing)
    private lazy var transitioningDelegate : SlideUpTransitionAnimator = { return SlideUpTransitionAnimator() }()
    private var navigationController : UINavigationController!
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStyle, mode: CopingAndSoothingMode, isIntro: Bool) {
        var moduleDependencies = CopingAndSoothingDetailDependencies()
        moduleDependencies.wireframe = self
        moduleDependencies.csActivityDataStore = DataStoreFactory.csActivityDataStore(networkManager: dependencies.networkManager)
        moduleDependencies.interactor = CopingAndSoothingDetailFactory.interactor(moduleDependencies)
        
        var presenter = CopingAndSoothingDetailFactory.presenter(moduleDependencies, mode: mode, isIntro: isIntro)
        let viewController: CopingAndSoothingDetailViewController = storyboard.viewController()
        viewController.title = mode.title
        viewController.style = dependencies.style
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        navigationController = dependencies.navigationController
        navigationController.mfl_present(viewController,
                                         transitioningDelegate: transitioningDelegate,
                                         navigationBarClass: MFLCommon.shared.navigationBarClassLight)
    }
    
    func close() {
        navigationController.dismiss(animated: true) { [weak self] in
            guard let sself = self else { return }
            sself.delegate?.copingAndSoothingDetailWireframeDidClose(sself)
        }
    }
    
    func finish(_ mode: CopingAndSoothingMode) {
        navigationController.dismiss(animated: true) { [weak self] in
            guard let sself = self else { return }
            sself.delegate?.copingAndSoothingDetailWireframe(sself, didFinishWith: mode)
        }
    }
}

fileprivate extension CopingAndSoothingMode {
    var title : String {
        switch self {
        case .doLess: return NSLocalizedString("Do Less", comment: "")
        case .doMore: return NSLocalizedString("Do More", comment: "")
        }
    }
}

