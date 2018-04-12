//
//  ToolsPresenter.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 11/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class ToolsPresenterImplementation: ToolsPresenter {
    
    weak var delegate: ToolsPresenterDelegate?
    
    fileprivate let interactor : ToolsInteractor
    fileprivate let wireframe : ToolsWireframe
    fileprivate let sections : [DisplayTool]
    
    typealias Dependencies = HasToolsWireframe & HasToolsInteractor
    init(_ dependencies: Dependencies, tools: [DisplayTool]) {
        interactor = dependencies.interactor
        wireframe = dependencies.wireframe
        sections = tools
    }
    
    var sectionsCount: Int {
        return 1
    }
    
    func numberOfEntries(in section: Int) -> Int {
        return self.sections.count
    }
    
    func toolsEntry(at indexPath: IndexPath) -> ToolsCollectionViewCell.CellData {
        let item = self.sections[indexPath.row]
        let imageName = mfl_isValid(interactor.user().userPackage) ? item.imageName : "\(item.imageName)_block"
        return ToolsCollectionViewCell.CellData(imageName: imageName, title: item.title)
    }
    
    func openTool(index: Int) {
        let toolName = sections[index].title
        
        if mfl_isValid(interactor.user().userPackage) {
            MFLAnalytics.record(event: .buttonTap(name: "Tool Tapped - \(toolName)", value: nil))
            wireframe.presentTool(index: index)
        }
        else {
            MFLAnalytics.record(event: .buttonTap(name: "Locked Tool Tapped - \(toolName)", value: nil))
            wireframe.presentSubscription()
        }
        delegate?.toolsPresenter(self, wantsToShowInfo: nil,
                                 button: nil,
                                 action: nil) // Hide Info View
    }
    
    func updateQuestionnaireInfo(message: String?, buttonText: String?) {
        delegate?.toolsPresenter(self, wantsToShowInfo: message, button: buttonText) { [unowned self] in
            self.interactor.userWantsToStartQuestionary()
        }
    }
}


