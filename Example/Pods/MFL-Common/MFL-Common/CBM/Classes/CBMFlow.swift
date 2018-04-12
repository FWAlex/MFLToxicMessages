//
//  CBMFlow.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 07/03/2018.
//

import Foundation

public class CBMFlow {
    
    public typealias CBMFlowDependencies = HasNavigationController & HasNetworkManager & HasStyle
    fileprivate var dependencies : CBMFlowDependencies!
    let navigationDelegate : UINavigationControllerDelegate = CBMFlowNavigationDelegate()
    
    public init() { /* Empty */ }
    
    public func start(_ dependencies: CBMFlowDependencies) {
        self.dependencies = dependencies
        
        NotificationCenter.default.addObserver(self, selector: #selector(CBMFlow.foo), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        if let uuid = UserDefaults.mfl_cbmUUID, !uuid.isEmpty {
            moveToCBMSessioInfoPage(replace: false)
        } else {
            moveToCBMLoginPage()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func foo() {
        popToInfoScreenIfNeeded()
    }
}

//MARK: - Navigation
private extension CBMFlow {
    
    func moveToCBMLoginPage() {
        let viewController = CBMLoginFactory.wireframe().viewController(dependencies,
                                                                        actions: [.continue : moveToCBMSessioInfoPage(saving:)])
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func moveToCBMSessioInfoPage(saving uuid: String) {
        UserDefaults.mfl_cbmUUID = uuid
        moveToCBMSessioInfoPage(replace: true)
    }
    
    func moveToCBMSessioInfoPage(replace: Bool) {
        guard let uuid = UserDefaults.mfl_cbmUUID, !uuid.isEmpty else {
            assertionFailure("User is not logged in")
            return
        }
        
        let viewController = CBMSessionInfoFactory.wireframe().viewController(dependencies, uuid: uuid, actions: [.continue : moveToCMBTrial])
        dependencies.navigationController.mfl_show(viewController, sender: self, replaceTop: replace)
    }
    
    func moveToCMBTrial(session: CBMSession) {
        let viewController = CBMPerformSessionFactory.wireframe().viewController(dependencies, session: session, actions: [.sessionFinished : moveToCMBFinal])
        dependencies.navigationController.delegate = navigationDelegate
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func moveToCMBFinal(session: CBMSession) {
        let viewController = CBMFinalScreenFactory.wireframe().viewController(dependencies, session: session, actions: [.startNewSession: startNewSession])
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func startNewSession() {
        moveToCBMSessioInfoPage(replace: true)
    }
}

//MARK: - Helper
private extension CBMFlow {
    func popToInfoScreenIfNeeded() {
        if let topViewController = dependencies.navigationController.topViewController,
            topViewController is CBMPerformSessionViewController {
            dependencies.navigationController.mfl_pop(to: CBMSessionInfoViewController.self, animated: false)
        }
    }
}

private class CBMFlowNavigationDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transitioningDelegate = MaterialTransitionAnimator(isPresenting: true)
        return transitioningDelegate
    }
}

