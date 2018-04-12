//
//  AllowSleepDataViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/06/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

protocol AllowSleepDataViewControllerDelegate : class {
    func allowSleepDataViewController(_ sender: AllowSleepDataViewController, didGrantPermission isPermissionGranted: Bool)
}

class AllowSleepDataViewController: MFLViewController {
    
    weak var delegate : AllowSleepDataViewControllerDelegate?
    
    @IBAction func didTapAllow(_ sender: Any) {
        delegate?.allowSleepDataViewController(self, didGrantPermission: true)
    }
    
    
    @IBAction func didTapCancel(_ sender: Any) {
        delegate?.allowSleepDataViewController(self, didGrantPermission: false)
    }
    
}


