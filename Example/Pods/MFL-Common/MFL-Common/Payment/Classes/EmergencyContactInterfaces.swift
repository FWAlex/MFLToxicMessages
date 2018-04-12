//
//  EmergencyContactInterfaces.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 28/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit


//MARK: - Interactor
protocol EmergencyContactInteractor {
    
    var isDeviceSupportingApplePay : Bool { get }
    var hasUserCardSaved : Bool { get }
    
    func currentUser() -> User!
    func updateUser(ice: ICE, handler: @escaping (Error?) -> Void)
    func applePay(for payable: Payable, on viewController: UIViewController, completion: @escaping (Error?) -> Void)
    func payFor(_ bolton: Bolton, handler: @escaping PaymentManager.CardCompletion)
}

//MARK: - Presenter

protocol EmergencyContactPresenterDelegate : class {
    func emergencyContactPresenterDidStartUpdate(_ sender: EmergencyContactPresenter)
    func emergencyContactPresenter(_ sender: EmergencyContactPresenter, didFinishUpdateWith error: Error?)
    func emergencyContactPresenter(_ sender: EmergencyContactPresenter, wantsToPresent alert: UIAlertController)
    func emergencyContactPresenter(_ sender: EmergencyContactPresenter, wantsToPresent error: Error)
}

protocol EmergencyContactPresenter {
    
    weak var delegate : EmergencyContactPresenterDelegate? { get set }
    
    var ice : EmergencyContactData? { get }
    var isDeviceSupportingApplePay : Bool { get }
    var hasUserCardSaved : Bool { get }
    var infoTitle : String { get }
    var infoText : String { get }
    
    func validate(phoneNumber: String?) -> String?
    func validate(firstName: String?) -> String?
    func validate(lastName: String?) -> String?
    func validate(relationship: String?) -> String?
    
    func submitEmergencyContactAndContinue(phoneNumber: String?,
                                           firstName: String?,
                                           lastName: String?,
                                           relationship: String?) throws
    
    func submitEmergencyContactAndApplePay(phoneNumber: String?,
                                           firstName: String?,
                                           lastName: String?,
                                           relationship: String?,
                                           viewController: UIViewController) throws
}

//MARK: - Wireframe

protocol EmergencyContactWireframeDelegate : class {
    func emergencyContactWireframe(_ sender: EmergencyContactWireframe, wantsToShowPayWithCardPageFor payable: Payable)
    func emergencyContactWireframeWantsToFinish(_ sender: EmergencyContactWireframe)
}

protocol EmergencyContactWireframe {
    
    weak var delegate : EmergencyContactWireframeDelegate? { get set }
    
    func start(_ dependencies: HasNavigationController & HasNetworkManager & HasStoryboard & HasUserDataStore & HasPayable & HasStyle)
    
    func showPayWithCardPage(for payable: Payable)
    func finish()
}
