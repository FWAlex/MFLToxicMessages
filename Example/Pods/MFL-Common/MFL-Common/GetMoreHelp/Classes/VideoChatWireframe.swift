//
//  VideoChatWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 16/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class VideoChatWireframeImplementation : VideoChatWireframe {
    
    fileprivate lazy var storyboard : UIStoryboard = { return UIStoryboard(name: "GetMoreHelp", bundle: .getMoreHelp) }()
    fileprivate var presentingViewController : UIViewController!
    
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasSession & HasVideoChatProvider) {
        
        presentingViewController = dependencies.navigationController
        
        var moduleDependencies = VideoChatDependencies()
        moduleDependencies.videoChatWireframe = self
        moduleDependencies.videoChatInteractor = VideoChatFactory.interactor()
        moduleDependencies.videoSessionManager = VideoSessionManager(dependencies)
        moduleDependencies.session = dependencies.session
        
        var presenter = VideoChatFactory.presenter(moduleDependencies)
        let viewController: VideoChatViewController = storyboard.viewController()
        
        viewController.presenter = presenter
        presenter.delegate = viewController
        
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    func close() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
