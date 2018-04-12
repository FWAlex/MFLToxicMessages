//
//  CBMPerformSessionPresenter.swift
//  Pods
//
//  Created by Alex Miculescu on 13/03/2018.
//
//

import UIKit

struct CBMPerformSessionImagesDisplay {
    let imageOne : UIImage?
    let imageTwo : UIImage?
}

class CBMPerformSessionPresenterImplementation: CBMPerformSessionPresenter {
    
    weak var delegate : CBMPerformSessionPresenterDelegate?
    
    //MARK: - Exposed
    func focus() {
        delegate?.performSessionPresenterWantsToPresentFocus(self)
    }
    
    func enableInput() {
        delegate?.performSessionPresenter(self, wantsToSetInputEnabled: true)
    }
    
    func disableInput() {
        delegate?.performSessionPresenter(self, wantsToSetInputEnabled: false)
    }
    
    func showImages(for trial: CBMTrial) {
        let imagesDisplay = CBMPerformSessionImagesDisplay(imageOne: UIImage(withPrefetchedImageUrl: trial.imageOneURLString),
                                                           imageTwo: UIImage(withPrefetchedImageUrl: trial.imageTwoURLString))
        delegate?.performSessionPresenter(self, wantsToPresentImages: imagesDisplay)
    }
    
    func hideImages() {
        delegate?.performSessionPresenterWantsToHideImages(self)
    }
    
    func showProbe(type probeType: ProbeType, for trial: CBMTrial) {
        let porbeImages = CBMPerformSessionImagesDisplay(imageOne: trial.probePosition == .imageOne ? probeType.image : nil,
                                                         imageTwo: trial.probePosition == .imageTwo ? probeType.image : nil)
        delegate?.performSessionPresenter(self, wantsToPresentProbes: porbeImages)
    }
    
    func hideProbes() {
        delegate?.performSessionPresenterWantsToHideProbes(self)
    }
    
    func showFailureToSelect() {
        let message = NSLocalizedString("Oops!\nToo slow.", comment: "")
        delegate?.performSessionPresenter(self, wantsToShowMessage: message)
    }
    
    func showBadSelection() {
        let message = NSLocalizedString("Oops!\nNot the right letter.", comment: "")
        delegate?.performSessionPresenter(self, wantsToShowMessage: message)
    }
    
    func hideMessage() {
        delegate?.performSessionPresenterWantsToHideMessage(self)
    }
}

//MARK: - Helper
extension ProbeType {
    var image : UIImage? {
        switch self {
        case .e: return UIImage(named: "probe_e", bundle: .cbm)
        case .f: return UIImage(named: "probe_f", bundle: .cbm)
        }
    }
}
