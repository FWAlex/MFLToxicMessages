//
//  PaymentFlow.swift
//  Pods
//
//  Created by Alex Miculescu on 05/09/2017.
//
//

import UIKit

public enum PaymentFlowType {
    case subscription
    case boltons
}

public protocol PaymentFlowDelegate : class {
    func paymentFlowDidFinish(_ sender: PaymentFlow)
}

open class PaymentFlow {
    
    public weak var delegate : PaymentFlowDelegate?
    
    fileprivate lazy var dependencies : PaymentFlowDependencies = {
       var dependencies = PaymentFlowDependencies()
        dependencies.storyboard = UIStoryboard(name: "Payment", bundle: .payment)
        
        return dependencies
    }()

    public init() {}
    
    weak var presentingNavigationController : UINavigationController?
    
    open func start(_ dependencies: HasNavigationController & HasNetworkManager & HasUserDataStore & HasStyle & HasBoltonDataStore & HasPackageDataStore, type: PaymentFlowType) {
        presentingNavigationController = dependencies.navigationController
        self.dependencies.navigationController = dependencies.navigationController
        self.dependencies.networkManager = dependencies.networkManager
        self.dependencies.userDataStore = dependencies.userDataStore
        self.dependencies.boltonDataStore = dependencies.boltonDataStore
        self.dependencies.packageDataStore = dependencies.packageDataStore
        self.dependencies.style = dependencies.style

        switch type {
        case .subscription: moveToPackagesPage()
        case .boltons: moveToBoltonsListPage()
        }
    }
}

//MARK: - Navigation
extension PaymentFlow {
    
    func moveToPayWithCardPage(with payable: Payable, alertText: AlertText?) {
        var wireframe = PayWithCardFactory.wireframe()
        wireframe.delegate = self
        let viewController = wireframe.start(dependencies, payable: payable, alertText: alertText)
        if let viewController = viewController as? MFLViewController {
            viewController.statusBarStyle = .default
        }
        dependencies.navigationController.mfl_show(viewController, sender: self)
    }
    
    func moveToEmergencyContactPage() {
        var wireframe = EmergencyContactFactory.wireframe()
        wireframe.delegate = self
        wireframe.start(dependencies)
    }
    
    func moveToBoltonsListPage() {
        var wireframe = BoltonsListFactory.wireframe()
        wireframe.delegate = self
        if let navigationController = wireframe.start(dependencies) {
            dependencies.navigationController = navigationController
        }
    }
    
    func moveToPackagesPage() {
        var wireframe = PackagesFactory.wireframe()
        wireframe.delegate = self
        if let navigationController = wireframe.start(dependencies) {
            dependencies.navigationController = navigationController
        }
    }
    
    func moveToTermsAndConditionsPage() {
        BrandingInfoFactory.wireframe().start(dependencies, type: .termsAndConditions, asPush: true)
    }
}

//MARK: - PackagesWireframeDelegate
extension PaymentFlow : PackagesWireframeDelegate {
    func packagesWireframeDidClose(_ sender: PackagesWireframe) {
        delegate?.paymentFlowDidFinish(self)
        NotificationCenter.default.post(name: MFLSubscriptionDidFinish, object: nil)
    }
    
    func packagesWireframeWantsToPresentTermsAndConditions(_ sender: PackagesWireframe) {
        moveToTermsAndConditionsPage()
    }
    
    func packagesWireframe(_ sender: PackagesWireframe, wantsToPayWithCardFor package: Package) {
        let alertText = AlertText(title: NSLocalizedString("Welcome!", comment: ""),
                                  message: NSLocalizedString("You have just purchased \(package.name). You can enjoy the full functionality of the app.", comment: ""))
        moveToPayWithCardPage(with: package, alertText: alertText)
    }
}

//MARK: - BoltonsListWireframeDelegate
extension PaymentFlow : BoltonsListWireframeDelegate {
    func boltonsListWireframeDidClose(_ sender: BoltonsListWireframe) {
        delegate?.paymentFlowDidFinish(self)
    }
    
    func boltonsListWireframe(_ sender: BoltonsListWireframe, wantsToContinueWith payable: Payable) {
        dependencies.payable = payable
        moveToEmergencyContactPage()
    }
}

//MARK: - EmergencyContactWireframeDelegate
extension PaymentFlow : EmergencyContactWireframeDelegate {
    func emergencyContactWireframeWantsToFinish(_ sender: EmergencyContactWireframe) {
        presentingNavigationController?.dismiss(animated: true) { [ unowned self] in
            self.delegate?.paymentFlowDidFinish(self)
        }
        NotificationCenter.default.post(name: MFLSubscriptionDidFinish, object: nil)
    }
    
    func emergencyContactWireframe(_ sender: EmergencyContactWireframe, wantsToShowPayWithCardPageFor payable: Payable) {
        let alertText = AlertText(title: NSLocalizedString("Success", comment: ""),
                                  message: NSLocalizedString("You have just purchased \(payable.name)", comment: ""))
        moveToPayWithCardPage(with: payable, alertText: alertText)
    }
}

//MARK: - PayWithCardWireframeDelegate
extension PaymentFlow : PayWithCardWireframeDelegate {
    func payWithCardWireframeDidFinish(_ sender: PayWithCardWireframe) {
        presentingNavigationController?.dismiss(animated: true) { [ unowned self] in
            self.delegate?.paymentFlowDidFinish(self)
        }
        NotificationCenter.default.post(name: MFLSubscriptionDidFinish, object: nil)
    }
}

struct PaymentFlowDependencies : HasStoryboard, HasNavigationController, HasNetworkManager, HasUserDataStore, HasStyle, HasPayable, HasBoltonDataStore, HasPackageDataStore {
    var storyboard : UIStoryboard!
    var navigationController : UINavigationController!
    var networkManager : NetworkManager!
    var userDataStore : UserDataStore!
    var style : Style!
    var payable: Payable!
    var boltonDataStore: BoltonDataStore!
    var packageDataStore: PackageDataStore!
}
