//
//  PayWithCardWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 01/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class PayWithCardWireframeImplementation : PayWithCardWireframe {

    weak var delegate : PayWithCardWireframeDelegate?
    fileprivate var navigationController : UINavigationController?
    private lazy var storyboard : UIStoryboard = { return UIStoryboard(name: "Payment", bundle: .payment) }()
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasUserDataStore & HasStyle, payable: Payable?, alertText: AlertText?) -> UIViewController {
        
        navigationController = dependencies.navigationController
        
        var payWithCardDependencies = PayWithCardDependencies()
        
        payWithCardDependencies.payWithCardWireframe = self
        payWithCardDependencies.paymentManager = PaymentManager(userDataStore: dependencies.userDataStore,
                                                                networkManager: dependencies.networkManager)
        
        let interactor = PayWithCardFactory.interactor(payWithCardDependencies)
        payWithCardDependencies.payWithCardInteractor = interactor
        
        var presenter = PayWithCardFactory.presenter(payWithCardDependencies, payable: payable, alertText: alertText)
        
        let viewController: PayWithCardViewController = storyboard.viewController()
        viewController.title = NSLocalizedString("Card Details", comment: "")
        viewController.presenter = presenter
        viewController.style = dependencies.style
        
        presenter.delegate = viewController
        
        return viewController
    }
    
    func finish() {
        self.delegate?.payWithCardWireframeDidFinish(self)
    }
}


