//
//  ForumFlow.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import UIKit

public class ForumFlow {
    
    fileprivate lazy var dependencies : ForumFlowDependencies = {
        var dependencies = ForumFlowDependencies()
        dependencies.storyboard = UIStoryboard(name: "Forum", bundle: .forum)
        
        return dependencies
    }()
    
    fileprivate var urlString : String!
    fileprivate var platform: String!
    fileprivate var paymentFlow : PaymentFlow?
    
    public typealias Dependencies = HasNavigationController & HasNetworkManager & HasBoltonDataStore & HasPackageDataStore & HasStyle & HasUserPresistentStore & HasUserDataStore & HasQuestionnaireTracker & HasRTCManager
    
    public init(_ dependencies: Dependencies, urlString: String) {
        self.dependencies.navigationController = dependencies.navigationController
        self.urlString = urlString
        self.dependencies.networkManager = dependencies.networkManager
        self.dependencies.boltonDataStore = dependencies.boltonDataStore
        self.dependencies.packageDataStore = dependencies.packageDataStore
        self.dependencies.style = dependencies.style
        self.dependencies.userPersistentStore = dependencies.userPersistentStore
        self.dependencies.userDataStore = dependencies.userDataStore
        self.dependencies.rtcManager = dependencies.rtcManager
        self.dependencies.questionnaireTracker = dependencies.questionnaireTracker
        
        NotificationCenter.default.addObserver(self, selector: #selector(subscriptionDidFinish), name: MFLSubscriptionDidFinish, object: nil)
        
        moveToAppropiatePage(asPush: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func isUserSubscribed() -> Bool {
        let userDataStore = DataStoreFactory.userDataStore(with: dependencies)
        if let currentUser = userDataStore.currentUser(), mfl_isValid(currentUser.userPackage) {
            return true
        }
        
        return false
    }
    
    @objc fileprivate func subscriptionDidFinish() {
        // After a small delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            [weak self] in
            self?.moveToAppropiatePage(asPush: true)
        }
    }
}

//MARK: - Navigation

fileprivate extension ForumFlow {
    
    func moveToAppropiatePage(asPush: Bool) {
        if isUserSubscribed() {
            if let viewController = dependencies.navigationController.viewControllers.last, !(viewController is LockedForumViewController) {
                return
            }
            moveToForumPage(asPush: asPush)
        } else {
            if let viewController = dependencies.navigationController.viewControllers.last, !(viewController is ForumViewController) {
                return
            }
            moveToLockedForumPage(asPush: asPush)
        }
    }
    
    func moveToForumPage(asPush: Bool) {
        ForumFactory.wireframe().start(dependencies, urlString: urlString, asPush: asPush)
    }
    
    func moveToLockedForumPage(asPush: Bool) {
        var wireframe = LockedForumFactory.wireframe()
        wireframe.delegate = self
        wireframe.start(dependencies, asPush: asPush)
    }
    
    func startSubscribeFlow() {
        paymentFlow = PaymentFlow()
        paymentFlow?.start(dependencies, type: .subscription)
    }
}

//MARK: - LockedForumWireframeDelegate
extension ForumFlow : LockedForumWireframeDelegate {
    func lockedForumWireframeWantsToPresentPackagesPage(_ sender: LockedForumWireframe) {
        startSubscribeFlow()
    }
}

//MARK: - Dependencies
struct ForumFlowDependencies : HasNavigationController, HasStoryboard, HasNetworkManager, HasBoltonDataStore, HasPackageDataStore, HasStyle, HasUserPresistentStore, HasUserDataStore, HasQuestionnaireTracker, HasRTCManager {
    var navigationController: UINavigationController!
    var storyboard: UIStoryboard!
    var networkManager: NetworkManager!
    var boltonDataStore: BoltonDataStore!
    var packageDataStore: PackageDataStore!
    var style: Style!
    var userPersistentStore: UserPersistentStore!
    var userDataStore: UserDataStore!
    var rtcManager: RTCManager!
    var questionnaireTracker: QuestionnaireTracker!
}

