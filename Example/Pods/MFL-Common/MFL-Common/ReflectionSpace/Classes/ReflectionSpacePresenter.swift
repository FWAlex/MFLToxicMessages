//
//  ReflectionSpacePresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 03/10/2017.
//
//

import UIKit
import AVFoundation

class ReflectionSpacePresenterImplementation: ReflectionSpacePresenter {

    weak var delegate : ReflectionSpacePresenterDelegate?
    fileprivate let interactor: ReflectionSpaceInteractor
    fileprivate let wireframe: ReflectionSpaceWireframe
    fileprivate var items = [ReflectionSpaceItem]()
    fileprivate var displayItems = [ReflectionSpaceItemDisplay]()
    fileprivate var selectedIndexes = [Int]()
    
    typealias Dependencies = HasReflectionSpaceWireframe & HasReflectionSpaceInteractor
    init(_ dependencies: Dependencies) {
        interactor = dependencies.interactor
        wireframe = dependencies.wireframe
    }
    
    func viewDidLoad() {
        
        delegate?.reflectionSpacePresenter(self, wantsToShowActivity: true)
        
        DispatchQueue(label: "refresh").async { [unowned self] in
            self.refreshItems()
        }
    }
    
    var numberOfItems: Int { return items.count }
    
    func item(at index: Int) -> ReflectionSpaceItemDisplay {
        return displayItems[index]
    }
    
    func heightForItem(at index: Int, toFit width: CGFloat) -> CGFloat {
        guard let image = displayItems[index].image else { return 0.0 }
        let aspectRatio = image.size.height / image.size.width
        return aspectRatio * width
    }
    
    func userWantsToAdd() {
        MFLAnalytics.record(event: .buttonTap(name: "Reflection Space Add Tapped", value: nil))
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
       
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""),
                                         style: .default,
                                         handler: presentCamera)
        
        let libraryAction = UIAlertAction(title: NSLocalizedString("Photo & Video Library", comment: ""),
                                          style: .default,
                                          handler: presentLibrary)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel,
                                         handler: nil)
        
        actionSheet.add([cameraAction, libraryAction, cancelAction])
        
        delegate?.reflectionSpacePresenter(self, wantsToShow: actionSheet)
    }
    
    func userWantsToViewItem(at index: Int) {
        wireframe.present(items[index].type) { [weak self] in
            self?.deleteItems(at: [index])
        }
    }
    
    func deselectAllItems() {
        selectedIndexes = [Int]()
        updateDeletionAllowedState()
    }
    
    func userSelectedItem(at index: Int) {
        if selectedIndexes.contains(index) { selectedIndexes.remove(where: { $0 == index }) }
        else { selectedIndexes.append(index) }
        delegate?.reflectionSpacePresenter(self, didUpdateSelectedItemsCount: selectedIndexes.count)
        updateDeletionAllowedState()
    }
    
    func isSelectedItem(at index: Int) -> Bool {
        return selectedIndexes.contains(index)
    }
    
    fileprivate func updateDeletionAllowedState() {
        delegate?.reflectionSpacePresenter(self, wantsToAllowItemDeletion: selectedIndexes.count > 0)
    }
    
    func userWantsToDeleteSelectedItems() {
        let alert = UIAlertController(title: NSLocalizedString("Delete", comment: ""),
                                      message: NSLocalizedString("Are you sure you want to delete", comment: "") + " \(selectedIndexes.count) " + NSLocalizedString("items?", comment: ""),
                                      preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive) { _ in
            self.deleteItems(at: self.selectedIndexes)
            self.deselectAllItems()
        }
        
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)
        
        alert.add([yesAction, noAction])
        
        delegate?.reflectionSpacePresenter(self, wantsToShow: alert)
    }
    
    fileprivate func deleteItems(at indexes: [Int]) {
        let items = self.items[indexes]
        
        delegate?.reflectionSpacePresenter(self, wantsToShowActivity: true)
        DispatchQueue(label: "delete_item").async {
            for item in items {
                switch item.type {
                case .image(let name, let thumb):
                    FileManager.delete(name)
                    FileManager.delete(thumb)
                case .video(let name, let thumb):
                    FileManager.delete(name)
                    FileManager.delete(thumb)
                }
            }
            
            DispatchQueue.main.async {
                
                for item in items {
                    self.interactor.delete(item)
                }
                
                self.items.remove(at: indexes)
                self.displayItems.remove(at: indexes)
                
                self.delegate?.reflectionSpacePresenter(self, wantsToShowActivity: false)
                self.delegate?.reflectionSpacePresenter(self, didDeleteItemsAt: indexes)
                self.updateState()
            }
        }
    }
}

//MARK: - Helper
fileprivate extension ReflectionSpacePresenterImplementation {
    
    func refreshItems() {
        let items = interactor.getAllItems()
        let displayItems = interactor.getAllItems().map { ReflectionSpaceItemDisplay($0.type) }
        
        DispatchQueue.main.async {
            self.delegate?.reflectionSpacePresenter(self, wantsToShowActivity: false)
            self.items = items
            self.displayItems = displayItems
            self.updateState()
            self.delegate?.reflectionSpacePresenterWantsToReload(self)
        }
    }
    
    func updateState() {
        delegate?.reflectionSpacePresenter(self, wantsToSetEmptyState: items.count == 0)
    }
    
    func presentLibrary(_ action: UIAlertAction) {
        wireframe.presentLibraryImagePicker(callback: handleAddCallback)
    }
    
    func presentCamera(_ action: UIAlertAction) {
        wireframe.presentCameraImagePickler(callback: handleAddCallback)
    }
    
    func handleAddCallback(_ items: [ReflectionSpaceItemType], _ alert: UIAlertController?) {
        if let alert = alert {
            self.delegate?.reflectionSpacePresenter(self, wantsToShow: alert)
        } else {
            guard !items.isEmpty else { return }
            
            var savedItems = [ReflectionSpaceItem]()
            for item in items {
                savedItems.append(interactor.save(item))
            }

            displayItems.append(contentsOf: savedItems.map({ ReflectionSpaceItemDisplay($0.type) }))
            self.items.append(contentsOf: savedItems)
            updateState()
            
            MFLAnalytics.record(event: .thresholdPassed(name: "Reflection Space Item Added"))
            
            delegate?.reflectionSpacePresenter(self, didAddNewItems: items.count)
        }
    }
}

extension ReflectionSpaceItemDisplay {
    
    init(_ itemType: ReflectionSpaceItemType) {
        switch itemType {
        case .image(_, let thumbName):
            image = imageWith(thumbName)
            isVideo = false
            
        case .video(_, let thumbName):
            image = imageWith(thumbName)
            isVideo = true
        }
    }
}

fileprivate func imageWith(_ name: String) -> UIImage? {
    if let data = FileManager.data(named: name) { return UIImage(data: data) }
    else { return nil }
}
