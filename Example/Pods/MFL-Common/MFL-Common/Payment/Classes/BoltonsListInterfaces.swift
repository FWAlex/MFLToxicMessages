//
//  BoltonsListInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

//MARK: - Interactor


protocol BoltonsListInteractor {
    func fetchBoltons(handler: @escaping (Result<[Bolton]>) -> Void)
}

//MARK: - Presenter

protocol BoltonsListPresenterDelegate : class {
    func boltonsListPresenterRequiresViewController(_ sender: BoltonsListPresenter) -> UIViewController
    func boltonsListPresenter(_ sender: BoltonsListPresenter, wantsToShow boltons: [BoltonDisplay])
    func boltonsListPresenter(_ sender: BoltonsListPresenter, wantsToShowPrice price: String)
    func boltonsListPresenter(_ sender: BoltonsListPresenter, wantsToShowActivity inProgress: Bool)
    func boltonsListPresenter(_ sender: BoltonsListPresenter, wantsToShow alert: UIAlertController)
    func boltonsListPresenter(_ sender: BoltonsListPresenter, wantsToShow error: Error)
}

protocol BoltonsListPresenter {
    
    weak var delegate : BoltonsListPresenterDelegate? { get set }
    
    func viewDidLoad()
    func userSelectedBolton(at index: Int)
    func userWantsToContinue()
    func userWantsToClose()
}

//MARK: - Wireframe

protocol BoltonsListWireframeDelegate : class {
    func boltonsListWireframeDidClose(_ sender: BoltonsListWireframe)
    func boltonsListWireframe(_ sender: BoltonsListWireframe, wantsToContinueWith payable: Payable)
}

protocol BoltonsListWireframe {
    
    weak var delegate : BoltonsListWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasNetworkManager & HasBoltonDataStore & HasStyle) -> UINavigationController?
    
    func `continue`(with payable: Payable)
    func close()
}
