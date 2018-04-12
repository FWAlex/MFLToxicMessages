//
//  ReflectionSpaceWireframe.swift
//  Pods
//
//  Created by Alex Miculescu on 03/10/2017.
//
//

import UIKit
import MobileCoreServices
import Photos
import AVFoundation
import PKHUD
import DKImagePickerController

class ReflectionSpaceWireframeImplementation : ReflectionSpaceWireframe {
    
    fileprivate lazy var storyboard : UIStoryboard = {
        return UIStoryboard(name: "ReflectionSpace", bundle: .reflectionSpace)
    }()
    
    weak var delegate : ReflectionSpaceWireframeDelegate?
    fileprivate weak var navigationController : UINavigationController?
    fileprivate var imagePickerManager : ReflectionSpaceImagePickerManager?
    
    func start(_ dependencies: HasNavigationController & HasStyle) {
        navigationController = dependencies.navigationController
        imagePickerManager = ReflectionSpaceImagePickerManager(dependencies.navigationController)
        
        var moduleDependencies = ReflectionSpaceDependencies()
        moduleDependencies.wireframe = self
        moduleDependencies.reflectionSpaceItemDataStore = DataStoreFactory.reflectionSpaceItemDataStore()
        moduleDependencies.interactor = ReflectionSpaceFactory.interactor(moduleDependencies)
        
        var presenter = ReflectionSpaceFactory.presenter(moduleDependencies)
        let viewController: ReflectionSpaceViewController = storyboard.viewController()
        
        viewController.title = NSLocalizedString("Safe Space", comment: "")
        presenter.delegate = viewController
        viewController.style = dependencies.style
        viewController.presenter = presenter
        
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func presentLibraryImagePicker(callback: @escaping ReflectionSpaceContentCallback) {
        imagePickerManager?.presentImagePicker(from: .photoLibrary, callback: callback)
    }
    
    func presentCameraImagePickler(callback: @escaping ReflectionSpaceContentCallback) {
        imagePickerManager?.presentImagePicker(from: .camera, callback: callback)
    }
    
    func present(_ item: ReflectionSpaceItemType, with deleteAction: (() -> Void)?) {
        self.delegate?.reflectionSpaceWireframe(self, wantsToPresent: item, with: deleteAction)
    }
}


