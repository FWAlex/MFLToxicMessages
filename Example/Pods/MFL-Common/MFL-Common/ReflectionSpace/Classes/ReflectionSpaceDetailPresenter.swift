//
//  ReflectionSpaceDetailPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 06/10/2017.
//
//

import UIKit

class ReflectionSpaceDetailPresenterImplementation: ReflectionSpaceDetailPresenter {
    
    weak var delegate : ReflectionSpaceDetailPresenterDelegate?
    fileprivate let interactor : ReflectionSpaceDetailInteractor
    fileprivate let wireframe : ReflectionSpaceDetailWireframe
    let item : ReflectionSpaceItemType
    var displayItem = ReflectionSpaceDetailDisplayItem.image(nil)
    
    typealias Dependencies = HasReflectionSpaceDetailWireframe & HasReflectionSpaceDetailInteractor
    init(_ dependencies: Dependencies, item: ReflectionSpaceItemType) {
        interactor = dependencies.interactor
        wireframe = dependencies.wireframe
        self.item = item
        parseItem()
    }
    
    func userWantsToClose() {
        wireframe.close()
    }
    
    func userWantsToDelete() {
        let alert = UIAlertController(title: NSLocalizedString("Delete", comment: ""),
                                      message: NSLocalizedString("Are you sure you want to delete this item?", comment: ""),
                                      preferredStyle: .alert)
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive) { _ in self.wireframe.delete() }
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)
        alert.add([yesAction, noAction])
        
        delegate?.reflectionSpaceDetailPresenter(self, wantsToShow: alert)
    }
    
    fileprivate func parseItem() {
        switch item {
        case .image(let name, _):
            if let data = FileManager.data(named: name) { displayItem = .image(UIImage(data: data)) }
            else { displayItem = .image(nil) }
        case .video(let name, _):
            displayItem = .video(FileManager.videoSnapshotWith(name), FileManager.url(named: name))
        }
    }
}

enum ReflectionSpaceDetailDisplayItem {
    case image(UIImage?)
    case video(UIImage?, URL?)
}
