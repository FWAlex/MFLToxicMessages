//
//  PackagesPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import UIKit

fileprivate let termsAndConditionsLinkId = "termsAndConditionsLinkId"

class PackagesPresenterImplementation: PackagesPresenter {
    
    typealias Dependencies = HasPackagesWireframe & HasPackagesInteractor
    
    weak var delegate : PackagesPresenterDelegate?
    fileprivate let interactor : PackagesInteractor
    fileprivate let wireframe : PackagesWireframe
    fileprivate var currentPackageId : String?
    fileprivate var selectedPackage : Package?
    
    fileprivate var packages = [Package]()
    
    fileprivate let body1 = NSLocalizedString("Your membership ends on", comment: "")
    fileprivate let body2 = NSLocalizedString("We’ll debit", comment: "")
    fileprivate let body3 = NSLocalizedString("that day and", comment: "")
    fileprivate let body4 = NSLocalizedString("thereafter. You can cancel your membership any time. By accepting this payment you agree to these", comment: "")
    fileprivate let termsAndConditionsString = NSLocalizedString("Terms and Conditions", comment: "")
    
    fileprivate lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter
    }()
    
    fileprivate func normalMessage() -> String? {
        
        guard let package = selectedPackage else { return nil }
        
        let date = package.durationUnit.dateFrom(Date(), numberOfUnits: package.durationInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: date)
        
        return self.body1 + " " + dateString + ". " +
            self.body2 + " \(mfl_priceNumberFormatter.string(for: package.price)!) " +
            self.body3 + " \(package.durationUnit.display) " +
            self.body4
    }
    
    func paymentInfoAttrString(with style: Style) -> NSAttributedString? {
        
        guard let normalMessage = normalMessage() else { return nil }
        
        let str = normalMessage + " " + termsAndConditionsString + "."
        let attrStr = NSMutableAttributedString(string: str)
        attrStr.set(style: TextStyle(font: UIFont.systemFont(ofSize: 13, weight: UIFontWeightSemibold), lineHeight: 20),
                    color: style.textColor2,
                    alignment: .center)
        
        let range = (str as NSString).range(of: termsAndConditionsString)
        attrStr.addAttribute(NSLinkAttributeName, value: termsAndConditionsLinkId, range: range)
        attrStr.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        attrStr.addAttribute(NSUnderlineColorAttributeName, value: style.primary, range: range)

        
        return attrStr
    }
    
    init(_ dependencies: Dependencies, currentPackageId: String?) {
        self.interactor = dependencies.packagesInteractor
        self.wireframe = dependencies.packagesWireframe
        self.currentPackageId = currentPackageId
    }
    
    func viewDidLoad() {
        delegate?.packagesPresenterDidStartFetch(self)
        fetchPackages()
    }
    
    var currentPackageIndex : Int? {
        guard let currentPackageId = currentPackageId else { return nil }
        return packages.index(where: { $0.id == currentPackageId })
    }
    
    var isDeviceSupportingApplePay: Bool {
        return interactor.isDeviceSupportingApplePay
    }
    
    func userDidSelectPackage(at index: Int) {
        selectedPackage = packages[index]
        
        let priceString = NSLocalizedString("Pay", comment: "") + " " + (mfl_priceNumberFormatter.string(from: selectedPackage!.price as NSNumber) ?? "")
        delegate?.packagesPresenter(self, wantsToUpdate: priceString)
    }
    
    func userDidSelect(_ url: URL) {
        switch url.absoluteString {
        case termsAndConditionsLinkId: wireframe.presentTermsAndConditions()
        default: break
        }
    }
    
    func userWantsToPayWithCard() {
        guard let selectedPackage = selectedPackage else {
            showNoPackageAlert()
            return
        }
        
        MFLAnalytics.record(event: .buttonTap(name: "Selected Package - \(selectedPackage.name)", value: nil))
        MFLAnalytics.record(event: .buttonTap(name: "Pay With Card Tapped", value: nil))
        wireframe.payWithCard(for: selectedPackage)
    }
    
    func userWantsToApplePay(on viewController: UIViewController) {
        guard let selectedPackage = selectedPackage else {
            showNoPackageAlert()
            return
        }
        
        MFLAnalytics.record(event: .buttonTap(name: "Selected Package - \(selectedPackage.name)", value: nil))
        MFLAnalytics.record(event: .buttonTap(name: "Pay With Card Tapped", value: nil))
        interactor.applePayFor(selectedPackage, on: viewController) { [unowned self] error in
            
            if let error = error {
                self.delegate?.packagesPresenter(self, wantsToShow: error)
            } else {
                self.delegate?.packagesPresenter(self, wantsToShow: self.successAlert(for: selectedPackage))
            }
        }
    }
    
    func userWantsToClose() {
        MFLAnalytics.record(event: .buttonTap(name: "Subscription Screen Close Tapped", value: nil))
        wireframe.close()
    }
}

fileprivate extension PackagesPresenterImplementation {
    
    func fetchPackages() {
        interactor.fetchPackages { [unowned self] in
            switch $0 {
            case .success(let packages):
                self.packages = packages.sorted { $0.price < $1.price }
                self.delegate?.packagesPresenter(self, didUpdate: self.packages.map { PackageDisplay($0) }, error: nil)
            case .failure(let error): self.delegate?.packagesPresenter(self, didUpdate: [], error: error)
            }
        }
    }
    
    func showNoPackageAlert() {
        
        let alert = UIAlertController(title: NSLocalizedString("No Package Selected", comment: ""),
                                      message: NSLocalizedString("Please select a package before continuing", comment: ""),
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        delegate?.packagesPresenter(self, wantsToShow: alert)
    }
    
    fileprivate func successAlert(for package: Package) -> UIAlertController {
        
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""),
                                      message: NSLocalizedString("You have just purchased \(package.name).", comment: ""),
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .default) { _ in self.wireframe.close() }
        
        alert.addAction(okAction)
        
        return alert
    }
}

extension PackageDisplay {
    
    init(_ package: Package) {
        name = package.name
        price = package.price
        durationUnit = package.durationUnit
    }
}

fileprivate extension DurationUnit {
    var display : String {
        switch self {
        case .month: return "monthly"
        case .year: return "yearly"
        }
    }
}


