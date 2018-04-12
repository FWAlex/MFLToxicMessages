//
//  ForumInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

//MARK: - Interactor


protocol ForumInteractor {
    var presenter: ForumPresenter! { get set }
    func userWantsToStartQuestionary()
}

//MARK: - Presenter

protocol ForumPresenterDelegate : class {
    func forumPresenter(_ sender: ForumPresenter,
                        wantsToShowInfo text: String?,
                        button: String?,
                        action: (() -> Void)?)
}

protocol ForumPresenter {
    
    weak var delegate : ForumPresenterDelegate? { get set }
    var request : URLRequest? { get }
    func updateQuestionnaireInfo(message: String?, buttonText: String?)
}

//MARK: - Wireframe

protocol ForumWireframeDelegate : class {
    
}

public typealias ForumWireframeDependencies = HasNavigationController & HasStoryboard & HasQuestionnaireTracker & HasStyle

protocol ForumWireframe {
    
    weak var delegate : ForumWireframeDelegate? { get set }
    func start(_ dependencies: ForumWireframeDependencies, urlString: String, asPush: Bool)
}
