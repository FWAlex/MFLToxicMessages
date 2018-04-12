//
//  PackagesInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit


//MARK: - Interactor

protocol PackagesInteractor {
    func fetchPackages(handler: @escaping (Result<[Package]>) -> Void)
    var isDeviceSupportingApplePay : Bool { get }
    func applePayFor(_ package: Package, on viewController: UIViewController, handler: @escaping (Error?) -> Void)
}

//MARK: - Presenter

protocol PackagesPresenterDelegate : class {
    
    func packagesPresenterDidStartFetch(_ sender: PackagesPresenter)
    func packagesPresenter(_ sender: PackagesPresenter, didUpdate packages: [PackageDisplay], error: Error?)
    func packagesPresenter(_ sender: PackagesPresenter, wantsToUpdate price: String)
    func packagesPresenter(_ sender: PackagesPresenter, wantsToShow alert: UIAlertController)
    func packagesPresenter(_ sender: PackagesPresenter, wantsToShow error: Error)
    
}

protocol PackagesPresenter {
    
    weak var delegate : PackagesPresenterDelegate? { get set }
    
    var currentPackageIndex : Int? { get }
    var isDeviceSupportingApplePay : Bool { get }
    
    func viewDidLoad()
    func paymentInfoAttrString(with style: Style) -> NSAttributedString?
    func userDidSelectPackage(at index: Int)
    func userDidSelect(_ url: URL)
    func userWantsToPayWithCard()
    func userWantsToApplePay(on viewController: UIViewController)
    func userWantsToClose()
}

//MARK: - Wireframe

protocol PackagesWireframeDelegate : class {
    func packagesWireframe(_ sender: PackagesWireframe, wantsToPayWithCardFor package: Package)
    func packagesWireframeWantsToPresentTermsAndConditions(_ sender: PackagesWireframe)
    func packagesWireframeDidClose(_ sender: PackagesWireframe)
}

protocol PackagesWireframe {
    
    weak var delegate : PackagesWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStoryboard & HasPackageDataStore & HasUserDataStore & HasStyle) -> UINavigationController?
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStoryboard & HasPackageDataStore & HasUserDataStore & HasStyle, currentPackageId: String?) -> UINavigationController?
    
    func payWithCard(for package: Package)
    func presentTermsAndConditions()
    func close()
}
