//
//  ToolsInterfaces.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 11/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import MFL_Common

//MARK: - Interactor


protocol ToolsInteractor {
    var presenter: ToolsPresenter! { get set }
    
    func userWantsToStartQuestionary()
    func user() -> User
}

//MARK: - Presenter

protocol ToolsPresenterDelegate: class {
    
    func toolsPresenter(_ sender: ToolsPresenter,
                            wantsToShowInfo text: String?,
                            button: String?,
                            action: (()->Void)?)
}

protocol ToolsPresenter {
    
    weak var delegate: ToolsPresenterDelegate? { get set }
    var sectionsCount : Int { get }
    func numberOfEntries(in section: Int) -> Int
    func toolsEntry(at indexPath: IndexPath) -> ToolsCollectionViewCell.CellData
    
    func openTool(index: Int)
    func updateQuestionnaireInfo(message: String?, buttonText: String?)
    
}

//MARK: - Wireframe

public protocol ToolsWireframeDelegate : class {
    func toolsWireframeWantsToPresentToolPage(_ sender: ToolsWireframe, index: Int)
    func toolsWireframeWantsToSubscription(_ sender: ToolsWireframe)
}


public typealias ToolsWireframeDependencies = HasNavigationController & HasStyle & HasUserDataStore & HasNavigationItem & HasQuestionnaireTracker

public protocol ToolsWireframe {
    weak var delegate : ToolsWireframeDelegate? { get set }
    
    func start(_ dependencies: ToolsWireframeDependencies, tools: [DisplayTool])
    func presentTool(index: Int)
    func presentSubscription()
}
