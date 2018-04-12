//
//  PaymentManager.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 30/05/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import Stripe

struct CardDetails {
    let number : String?
    let cvc : String?
    let expirationMonth : Int
    let expirationYear : Int
    let address : String
    let postCode : String
}

fileprivate let genericError = MFLError(title: NSLocalizedString("Paymeny Error", comment:""),
                                        message: NSLocalizedString("There was an error processing the payment. Please try again", comment: ""))

public class PaymentManager: NSObject {
    
    fileprivate var didPaymentSucceed = false
    fileprivate var isPaymentAuthorized = false
    
    fileprivate let networkManager : NetworkManager
    fileprivate let userDataStore : UserDataStore
    fileprivate var payableToPayFor : Payable?
    fileprivate var errorToReport : Error?
    
    typealias CardCompletion = (Result<User?>) -> Void
    typealias ApplePayCompletion = (_ isCanceled: Bool, Result<User?>?) -> Void
    
    fileprivate var applePayCompletion : ApplePayCompletion?
    
    typealias Dependencies = HasNetworkManager & HasUserDataStore
    init(_ dependencies: Dependencies) {
        networkManager = dependencies.networkManager
        userDataStore = dependencies.userDataStore
        
        super.init()
    }
    
    init(userDataStore: UserDataStore, networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.userDataStore = userDataStore
        
        super.init()
    }
    
    static var isDeviceSupportingApplePay : Bool {
        return Stripe.deviceSupportsApplePay()
    }
    
    func addCard(with cardDetails: CardDetails, completion: @escaping CardCompletion) {
        STPAPIClient.shared().createToken(withCard: STPCardParams(cardDetails)) { [weak self] (token, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self?.networkManager.addCard(with: token!.tokenId) { [weak self] result in
                
                switch result {
                case .success(_): self?.fetchCard(for: nil, handler: completion)
                case .failure(let error): completion(.failure(error))
                }
            }
        }
    }
    
    
    func payFor(_ bolton: Bolton, using cardId: String, handler: CardCompletion?) {
        payableToPayFor = bolton
        networkManager.pay(for: bolton.id, cardId: cardId) { [weak self] result in
            self?.handlePayment(result: result, usingApplePay: false, handler: handler)
        }
    }
    
    func cardPay(for payable: Payable, using cardDetails: CardDetails, completion: @escaping CardCompletion) {
        
        STPAPIClient.shared().createToken(withCard: STPCardParams(cardDetails)) { [weak self] (token, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self?.pay(for: payable, using: token!.tokenId, handler: completion)
        }
        
    }
    
    func applePay(for payable: Payable, on viewController: UIViewController, completion: @escaping ApplePayCompletion) {
        
        payableToPayFor = payable
        applePayCompletion = completion
        
        guard let merchantId = STPPaymentConfiguration.shared().appleMerchantIdentifier else {
            // If the merchantId is not set we are considering that the user has canceled the transaction
            // This is a "just in case" it should not ever happen
            
            completion(true, .success(nil))
            return
        }
        
        let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: merchantId)
        paymentRequest.currencyCode = "GBP"
        
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: payable.name, amount: NSDecimalNumber(value: payable.price) )
        ]
        
        if Stripe.canSubmitPaymentRequest(paymentRequest) {
            let paymentAuthorizationVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            paymentAuthorizationVC.delegate = self
            viewController.present(paymentAuthorizationVC, animated: true, completion: nil)
        } else {
            // There is a problem with the Apple Pay configuration.
            completion(true, .success(nil))
        }
    }
    
    fileprivate func pay(for payable: Payable, using stripeToken: String, usingApplePay: Bool = false, handler: CardCompletion?) {
        
        payableToPayFor = payable
        
        if let bolton = payable as? Bolton {
            self.networkManager.pay(for: bolton.id, stripeToken: stripeToken) { [weak self] result in
                self?.handlePayment(result: result, usingApplePay: usingApplePay, handler: handler)
            }
        }
            
        else if let package = payable as? Package {
            self.networkManager.pay(for: package.id, using: stripeToken) { [weak self] result in
                self?.handlePayment(result: result, usingApplePay: usingApplePay, handler: handler)
            }
        }
            
        else {
            assertionFailure("The item you are trying to pay for is not recognized")
        }
    }
    
    fileprivate func handlePayment(result: Result<MFLJson>, usingApplePay: Bool, handler: CardCompletion?) {
        
        switch result {
        case .success(_):
            
            // If the payment succeeds track using Analytics
            
            // Piwik
            MFLAnalytics.record(event: .paymentConfirmation(name: "Payment Success - \(self.payableToPayFor?.name ?? "")",
                currency: "GBP",
                value: NSNumber(value: self.payableToPayFor?.price ?? 0.0)))
            
            // If the payment succeeds we refresh the user packages
            self.userDataStore.refreshUserPackages {
                
                switch $0 {
                    
                // If the update succeeds then retrieve the user card
                case .success(let user):
                    if !usingApplePay {
                        self.fetchCard(for: user, handler: handler)
                    } else {
                        handler?(.success(user))
                    }
                    
                // In case it fails pass on the error
                case .failure(let error): handler?(.failure(error))
                    
                }
            }
            
        // In case of failure
        case .failure(let error):
            
            // Track using Analytics
            // Piwik
            MFLAnalytics.record(event: .paymentFailed(name: "Payment Failed - \(self.payableToPayFor?.name ?? "")"))
            
            // Pass on the error
            handler?(.failure(error))
        }
        
    }
    
    fileprivate func fetchCard(for user: User?, handler: CardCompletion?) {
        
        userDataStore.fetchUserCard() {
            switch $0 {
            case .success(let newUser):
                if let newUser = newUser {
                    handler?(.success(newUser))
                }
                else { handler?(.success(user)) }
                
            case .failure(_) : handler?(.success(user))
            }
        }
    }
}

//MARK: - PKPaymentAuthorizationViewControllerDelegate
extension PaymentManager : PKPaymentAuthorizationViewControllerDelegate {
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        isPaymentAuthorized = true
        
        STPAPIClient.shared().createToken(with: payment) { [weak self] (token, error) in
            
            if let error = error {
                self?.errorToReport = error
                completion(.failure)
                return
            }
            
            guard let payable = self?.payableToPayFor else {
                self?.errorToReport = MFLError(title: NSLocalizedString("No Package", comment: ""),
                                               message: NSLocalizedString("Please select a Package to pay for", comment: ""))
                completion(.failure)
                return
            }
            
            self?.pay(for: payable, using: token!.tokenId, usingApplePay: true) {
                
                switch $0 {
                case .success(_):
                    self?.didPaymentSucceed = true
                    completion(.success)
                    
                case .failure(let error):
                    self?.didPaymentSucceed = false
                    self?.errorToReport = error
                    completion(.failure)
                }
            }
        }
    }
    
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        controller.presentingViewController?.dismiss(animated: true) { [unowned self] in
            
            if !self.isPaymentAuthorized {
                self.didPaymentSucceed = false
                self.applePayCompletion?(true, nil)
                // Piwik
                MFLAnalytics.record(event: .paymentFailed(name: "Payment Canceled - \(self.payableToPayFor?.name ?? "")"))
                return
            }
            
            // We know that the payment was authorised, retrun the flag to it's default value
            self.isPaymentAuthorized = false
            
            if self.didPaymentSucceed  {
                let user = self.userDataStore.currentUser()
                self.applePayCompletion?(false, .success(user))
            } else {
                let error = self.errorToReport != nil ? self.errorToReport! : genericError
                self.applePayCompletion?(false, .failure(error))
                
            }
            
            self.didPaymentSucceed = false
        }
    }
}

fileprivate extension STPCardParams {
    
    convenience init(_ cardDetails: CardDetails) {
        self.init()
        number = cardDetails.number
        cvc = cardDetails.cvc
        expMonth = UInt(cardDetails.expirationMonth)
        expYear = UInt(cardDetails.expirationYear)
        address.line1 = cardDetails.address
        address.postalCode = cardDetails.postCode
    }
}

