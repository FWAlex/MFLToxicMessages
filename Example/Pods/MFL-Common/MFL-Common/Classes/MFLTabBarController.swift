//
//  MFLTabBarController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/04/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

public class MFLTabBarController: UITabBarController {
    
    @IBInspectable public var hidesNavigationBar = false

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(hidesNavigationBar, animated: true)
    }
    
    public override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        MFLAnalytics.record(event: .buttonTap(name: "\(item.title ?? "") Tab", value: nil))
    }
}
