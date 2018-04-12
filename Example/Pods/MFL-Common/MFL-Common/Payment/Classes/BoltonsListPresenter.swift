//
//  BoltonsListPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 02/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import UIKit

class BoltonsListPresenterImplementation: BoltonsListPresenter {
    
    weak var delegate : BoltonsListPresenterDelegate?
    fileprivate let interactor: BoltonsListInteractor
    fileprivate let wireframe: BoltonsListWireframe
    fileprivate var boltons = [Bolton]()
    fileprivate var selectedBolton : Bolton?
    
    typealias Dependencies = HasBoltonsListWireframe & HasBoltonsListInteractor
    init(_ dependencies: Dependencies) {
        interactor = dependencies.boltonsListInteractor
        wireframe = dependencies.boltonsListWireframe
    }
    
    //MARK: - Exposed
    func viewDidLoad() {

        delegate?.boltonsListPresenter(self, wantsToShowActivity: true)
        
        interactor.fetchBoltons() { [unowned self] result in
            self.delegate?.boltonsListPresenter(self, wantsToShowActivity: false)
            
            switch result {
            case .success(let boltons):
                self.boltons = boltons
                self.delegate?.boltonsListPresenter(self, wantsToShow: boltons.map { BoltonDisplay($0) } )
                
            case .failure(let error): self.delegate?.boltonsListPresenter(self, wantsToShow: error)
            }
        }
    }
    
    func userSelectedBolton(at index: Int) {
        selectedBolton = boltons[index]
        
        if let price = mfl_priceNumberFormatter.string(from: NSNumber(value: selectedBolton?.price ?? 0.0)) {
            delegate?.boltonsListPresenter(self, wantsToShowPrice: "Pay \(price)")
        }
    }
    
    func userWantsToClose() {
        wireframe.close()
    }
    
    func userWantsToContinue() {
        guard let bolton = selectedBolton else {
            showNoBoltonSelectedError()
            return
        }
        
        MFLAnalytics.record(event: .buttonTap(name: "Purchase Video Sessions Next Tapped", value: nil))
        wireframe.continue(with: bolton)
    }
}

//MARK: - Helper

fileprivate extension BoltonsListPresenterImplementation {

    func showNoBoltonSelectedError() {
        let error = MFLError(title: NSLocalizedString("Select an option.", comment: ""),
                             message: NSLocalizedString("Please select which option you want to purchaise.", comment: ""))
        
        delegate?.boltonsListPresenter(self, wantsToShow: error)
    }
    
    fileprivate func successAlert(for bolton: Bolton) -> UIAlertController {
        
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""),
                                      message: NSLocalizedString("You have just purchased \(bolton.name).", comment: ""),
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .default) { _ in self.wireframe.close() }
        
        alert.addAction(okAction)
        
        return alert
    }
}

fileprivate extension BoltonDisplay {
    
    init(_ bolton: Bolton) {
        name = bolton.name
        priceText = mfl_priceNumberFormatter.string(from: NSNumber(value: bolton.price))
    }
    
}

