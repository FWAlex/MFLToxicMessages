//
//  VideoChatInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 14/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

//MARK: - Interactor

protocol VideoChatInteractor {
    
}

//MARK: - Presenter

protocol VideoChatPresenterDelegate: class {
    
    func presenterRequiresPublisherView(_ sender: VideoChatPresenter) -> UIView
    func presenterRequiresSubscriberView(_ sender: VideoChatPresenter) -> UIView
    func videoChatPresenter(_ sender: VideoChatPresenter, wantsToShowActivity inProgress: Bool)
    func videoChatPresenter(_ sender: VideoChatPresenter, wantsToShow alert: UIAlertController)
    func videoChatPresenter(_ sender: VideoChatPresenter, whatsToSetTeamMemberImageVisible isVisible: Bool)
    func videoChatPresenter(_ sender: VideoChatPresenter, whatsToSetWaitingMessageVisible isVisible: Bool)
    
    // --- Error
    func presenter(_ sender: VideoChatPresenter, errorOccurred error: Error)
}

protocol VideoChatPresenter {
    
    weak var delegate : VideoChatPresenterDelegate? { get set }
    
    var title : String { get }
    var waitingText : String { get }
    var teamMemberImageUrlString : String { get }
    var isCameraActive : Bool { get set }
    var isMicActive : Bool { get set }
    
    func viewDidLoad()
    func userWantsToClose()
}

//MARK: - Wireframe
protocol VideoChatWireframe {
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasSession & HasVideoChatProvider)
    func close()
}
