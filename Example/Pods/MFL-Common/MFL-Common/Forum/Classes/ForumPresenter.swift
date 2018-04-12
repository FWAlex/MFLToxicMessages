//
//  ForumPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class ForumPresenterImplementation: ForumPresenter {
    
    weak var delegate : ForumPresenterDelegate?
    fileprivate var interactor : ForumInteractor!
    fileprivate let wireframe : ForumWireframe
    fileprivate let urlString : String
    
    typealias Dependencies = HasForumWireframe & HasForumInteractor
    init(_ dependencies: Dependencies, urlString: String) {
        wireframe = dependencies.forumWireframe
        self.urlString = urlString
        self.interactor = dependencies.forumInteractor
    }
    
    var request : URLRequest? {
        guard let accessToken = UserDefaults.mfl_accessToken else { return nil }
        let urlString = self.urlString + "?accessToken=\(accessToken)"
        return URLRequest(url: URL(string: urlString)!)
    }
    
    func updateQuestionnaireInfo(message: String?, buttonText: String?) {
        delegate?.forumPresenter(self, wantsToShowInfo: message, button: buttonText) { [unowned self] in
            self.interactor.userWantsToStartQuestionary()
        }
    }
}
