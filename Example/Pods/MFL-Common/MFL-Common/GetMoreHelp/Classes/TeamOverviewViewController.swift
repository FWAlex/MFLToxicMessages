//
//  TeamOverviewViewController.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import PKHUD

class TeamOverviewViewController: MFLViewController {
    
    var presenter : TeamOverviewPresenter!
    var style : Style!
    
    @IBOutlet fileprivate weak var imagesStackView : UIStackView!
    @IBOutlet fileprivate weak var offlineView : UIView!
    @IBOutlet var imageViews: [RoundImageView]!
    
    private var offlineViewGradient : CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesNavigationBar = false

        gradientLayerColors = style.gradient
        shouldUseGradientBackground = true
        
        updateOfflineViewGradient()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.startTeamMemberFetch()
    }
    
    private func updateOfflineViewGradient() {
        offlineViewGradient = CAGradientLayer()
        offlineViewGradient?.colors = style.gradient.map { $0.cgColor }
        offlineViewGradient?.frame = offlineView.bounds

        offlineView.layer.insertSublayer(offlineViewGradient!, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        offlineViewGradient?.frame = offlineView.bounds
    }
}

extension TeamOverviewViewController : TeamOverviewPresenterDelegate {
    
    func teamOverviewPresenter(_ sender: TeamOverviewPresenter, didUpdate teamMembers: [TeamMemberOverviewDispalyData]) {
        imagesStackView.isHidden = teamMembers.count == 0
        offlineView.isHidden = !imagesStackView.isHidden
        update(with: teamMembers)
    }
    
    func teamOverviewPresenter(_ sender: TeamOverviewPresenter, wantsToShowActivity inProgress: Bool) {
        if inProgress { HUD.show(.progress) }
        else { HUD.hide() }
    }
}

extension TeamOverviewViewController {
    
    func update(with teamMembers: [TeamMemberOverviewDispalyData]) {
        for (index, imageView) in imageViews.enumerated() {
            if index < teamMembers.count {
                imageView.mfl_setImage(withUrlString: teamMembers[index].imageUrlString)
            } else {
                imageView.image = nil
            }
        }
    }
}

