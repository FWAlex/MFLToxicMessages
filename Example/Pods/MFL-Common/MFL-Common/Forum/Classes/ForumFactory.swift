//
//  ForumFactory.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

protocol HasForumWireframe {
    var forumWireframe: ForumWireframe! { get }
}


protocol HasForumInteractor {
    var forumInteractor: ForumInteractor! { get }
}

class ForumFactory {
    
    class func wireframe() -> ForumWireframe {
        return ForumWireframeImplementation()
    }
    
    class func interactor(_ dependencies:ForumDependencies ) -> ForumInteractor {
        return ForumInteractorImplementation(dependencies)
    }
    
    class func presenter(_ dependencies: ForumDependencies, urlString: String) -> ForumPresenter {
        return ForumPresenterImplementation(dependencies, urlString: urlString)
    }
}

struct ForumDependencies : HasForumInteractor, HasForumWireframe, HasQuestionnaireTracker {
    var forumWireframe: ForumWireframe!
    var questionnaireTracker: QuestionnaireTracker!
    var forumInteractor: ForumInteractor!
}
