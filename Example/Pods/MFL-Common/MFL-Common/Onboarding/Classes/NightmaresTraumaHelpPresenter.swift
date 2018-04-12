//
//  SuicidalHelpPresenter.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 10/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import UIKit

class NightmaresTraumaHelpPresenterImplementation: NightmaresTraumaHelpPresenter {
    
    let wireframe: NightmaresTraumaHelpWireframe
    
    init(wireframe: NightmaresTraumaHelpWireframe) {
        self.wireframe = wireframe
    }
    
    func userWantsToViewCounsellingApp() {
        if let counsellingURL = URL(string: MFLCommon.shared.counsellingAppURLScheme),
            UIApplication.shared.canOpenURL(counsellingURL) {
            UIApplication.shared.open(counsellingURL, options: [:], completionHandler: nil)
        }
        else if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(MFLCommon.shared.counsellingAppAppstoreID!)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func userWantsToCancel() {
        wireframe.dismiss()
    }
}
