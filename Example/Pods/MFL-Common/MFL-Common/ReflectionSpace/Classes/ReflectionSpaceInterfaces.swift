//
//  ReflectionSpaceInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 03/10/2017.
//
//

import UIKit

//MARK: - Interactor
protocol ReflectionSpaceInteractor {
    func save(_ item: ReflectionSpaceItemType) -> ReflectionSpaceItem
    func getAllItems() -> [ReflectionSpaceItem]
    func delete(_ item: ReflectionSpaceItem)
}

//MARK: - Presenter
protocol ReflectionSpacePresenterDelegate : class {
    func reflectionSpacePresenterWantsToReload(_ sender: ReflectionSpacePresenter)
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, wantsToShow alert: UIAlertController)
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, wantsToSetEmptyState visible: Bool)
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, wantsToShowActivity inProgress: Bool)
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, didAddNewItems count: Int)
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, didDeleteItemsAt indexes: [Int])
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, wantsToAllowItemDeletion isDeletionAllowed: Bool)
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, didUpdateSelectedItemsCount count: Int)
}

protocol ReflectionSpacePresenter {
    
    weak var delegate : ReflectionSpacePresenterDelegate? { get set }
    
    func viewDidLoad()
    var numberOfItems : Int { get }
    func item(at index: Int) -> ReflectionSpaceItemDisplay
    func heightForItem(at index: Int, toFit width: CGFloat) -> CGFloat
    func userWantsToAdd()
    func userWantsToViewItem(at index: Int)
    func userSelectedItem(at index: Int)
    func isSelectedItem(at index: Int) -> Bool
    func deselectAllItems()
    func userWantsToDeleteSelectedItems()
}

//MARK: - Wireframe

public protocol ReflectionSpaceWireframeDelegate : class {
    func reflectionSpaceWireframe(_ sender: ReflectionSpaceWireframe,
                                  wantsToPresent item: ReflectionSpaceItemType,
                                  with deleteAction: (() -> Void)?)
}

public typealias ReflectionSpaceContentCallback = ([ReflectionSpaceItemType], UIAlertController?) -> Void

public protocol ReflectionSpaceWireframe {
    
    weak var delegate : ReflectionSpaceWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStyle)
    
    func presentLibraryImagePicker(callback: @escaping ReflectionSpaceContentCallback)
    func presentCameraImagePickler(callback: @escaping ReflectionSpaceContentCallback)
    func present(_ item: ReflectionSpaceItemType, with deleteAction: (() -> Void)?)
}
