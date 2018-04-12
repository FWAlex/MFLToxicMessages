//
//  PackagesInteractor.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class PackagesInteractorImplementation: PackagesInteractor {
    
    typealias Dependencies = HasPackageDataStore & HasPaymentManager
    
    fileprivate let packagesDataStore : PackageDataStore
    fileprivate let paymentManager : PaymentManager
    
    init(_ dependencies: Dependencies) {
        self.packagesDataStore = dependencies.packageDataStore
        self.paymentManager = dependencies.paymentManager
    }
    
    func fetchPackages(handler: @escaping (Result<[Package]>) -> Void) {
        packagesDataStore.fetchPackages(handler: handler)
    }
    
    var isDeviceSupportingApplePay : Bool {
        return PaymentManager.isDeviceSupportingApplePay
    }
    
    func applePayFor(_ package: Package, on viewController: UIViewController, handler: @escaping (Error?) -> Void) {
       
        paymentManager.applePay(for: package, on: viewController) { isCanceled, result in
            guard !isCanceled, let result = result else { return }
            
            switch result {
            case .success(_): handler(nil)
            case .failure(let error): handler(error)
            }
        }
    }
}
