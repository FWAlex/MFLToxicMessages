//
//  CBMSessionInfoInteractor.swift
//  Pods
//
//  Created by Alex Miculescu on 08/03/2018.
//
//

import Foundation

class CBMSessionInfoInteractorImplementation: CBMSessionInfoInteractor {
    
    fileprivate let presenter : CBMSessionInfoPresenter
    fileprivate let uuid : String
    fileprivate let cbmDataStore : CBMDataStore
    fileprivate let actions : CBMSessionInfoActions?
    fileprivate var session : CBMSession?
    
    fileprivate var downloadedImages = 0
    fileprivate var imagesDownloadOperationQueue = OperationQueue()
    fileprivate var postponedUserAction: (() ->Void)?

    typealias CBMSessionInfoInteractorDependencies = HasCBMSessionInfoPresenter & HasCBMDataStore
    
    init(_ dependencies: CBMSessionInfoInteractorDependencies, uuid: String, actions: CBMSessionInfoActions?) {
        presenter = dependencies.presenter
        cbmDataStore = dependencies.cbmDataStore
        self.uuid = uuid
        self.actions = actions
    }
    
    func viewDidAppear() {
        startSessionFetch()
    }
    
    func userWantsToStartTrial() {
        
        if imagesDownloadOperationQueue.operations.count == 0 {
            self.continue()
        } else {
            presenter.showLoadingInProgress()
            postponedUserAction = {[weak self] in
               self?.continue()
            }
        }
    }
}

//MARK: - Helper
private extension CBMSessionInfoInteractorImplementation {
    
    func startSessionFetch() {
        cbmDataStore.fetchCBMSessions(for: uuid) { [unowned self] result in
            switch result {
            case .success(let sessions):
                if let session = sessions.first {
                    self.session = session
                    self.startImagedDownload(for: session)
                }
            case .failure(let error):
                self.presenter.presentError(error: error) { [weak self] in
                    self?.retrySessionFetch()
                }
            }
        }
    }
    
    func startImagedDownload(for session: CBMSession) {
        
        let imagesUrlSet = NSMutableSet()
        
        session.trials.forEach {
            imagesUrlSet.add($0.imageOneURLString)
            imagesUrlSet.add($0.imageTwoURLString)
        }
        
        imagesDownloadOperationQueue.isSuspended = true
        
        for imagesUrl in imagesUrlSet {
            let imageDownloader = ImageDownloader(imageUrlString: imagesUrl as! String)
            imageDownloader.successAction = { [unowned self] in
                self.downloadedImages += 1
                if (self.downloadedImages == imagesUrlSet.count) {
                    self.postponedUserAction?()
                }
            }
            
            imageDownloader.failureAction = { [unowned self] in
                self.imagesDownloadOperationQueue.isSuspended = true
                self.imagesDownloadOperationQueue.cancelAllOperations()
                self.presenter.presentError(error: nil) { [weak self] in
                    self?.retrySessionFetch()
                }
            }
            
            imagesDownloadOperationQueue.addOperation(imageDownloader)
        }
        
        imagesDownloadOperationQueue.isSuspended = false
    }
    
    func retrySessionFetch() {
        startSessionFetch()
    }
    
    func `continue`() {
        guard let actions = actions, let action = actions[.continue], let session = session else { return }
        guard let continueAction = action as? (_ session: CBMSession) -> Void else {
            preconditionFailure("The \".continue\" action does not have the expected type: (CBMSession) -> Void")
            return
        }
        continueAction(session)
    }
}

