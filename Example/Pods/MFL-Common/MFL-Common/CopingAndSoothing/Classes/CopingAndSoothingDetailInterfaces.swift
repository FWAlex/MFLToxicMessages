//
//  CopingAndSoothingDetailInterfaces.swift
//  Pods
//
//  Created by Alex Miculescu on 26/10/2017.
//
//

import UIKit

//MARK: - Interactor


protocol CopingAndSoothingDetailInteractor {
    func fetchActivities(handler: @escaping (Result<[CSActivity]>) -> Void)
    func addActivity(with text: String, type: CSActivityType, handler: @escaping (Result<CSActivity>) -> Void)
    func update(_ activity: CSActivity, handler: @escaping (Error?) -> Void)
}

//MARK: - Presenter

protocol CopingAndSoothingDetailPresenterDelegate : class {
    func copingAndSoothingDetailPresenterWantsToRefreshItems(_ sender: CopingAndSoothingDetailPresenter)
    func copingAndSoothingDetailPresenter(_ sender: CopingAndSoothingDetailPresenter, wantsToShowActivity inProgress: Bool)
    func copingAndSoothingDetailPresenter(_ sender: CopingAndSoothingDetailPresenter, wantsToPresent error: Error)
    func copingAndSoothingDetailPresenter(_ sender: CopingAndSoothingDetailPresenter, didAddNewItemAt index: Int)
    func copingAndSoothingDetailPresenter(_ sender: CopingAndSoothingDetailPresenter, didAddUpdateItemAt index: Int)
}

protocol CopingAndSoothingDetailPresenter {
    
    weak var delegate : CopingAndSoothingDetailPresenterDelegate? { get set }
    
    func viewWillAppear()
    var shouldShowCloseButton : Bool { get }
    var barButtonText : String { get }
    func userWantsToClose()
    func userWantsToFinish()
    
    var itemsCount : Int { get }
    func item(at index: Int) -> CopingAndSoothingDetailData
    var header : String { get }
    func userWantsToAdd(_ text: String)
    func userDidSelectItem(at index: Int)
}

//MARK: - Wireframe

protocol CopingAndSoothingDetailWireframeDelegate : class {
    func copingAndSoothingDetailWireframeDidClose(_ sender:  CopingAndSoothingDetailWireframe)
    func copingAndSoothingDetailWireframe(_ sender:  CopingAndSoothingDetailWireframe, didFinishWith mode: CopingAndSoothingMode)
}

protocol CopingAndSoothingDetailWireframe {
    
    weak var delegate : CopingAndSoothingDetailWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStyle, mode: CopingAndSoothingMode, isIntro: Bool)
    func close()
    func finish(_ mode: CopingAndSoothingMode)
}
