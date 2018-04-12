//
//  GoalDetailWireframe.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 13/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class GoalDetailWireframeImplementation : GoalDetailWireframe {
    
    weak var delegate : GoalDetailWireframeDelegate?
    weak var presentingNavController : UINavigationController!
    
    fileprivate var storyboard: UIStoryboard!
    fileprivate var transitioningDelegate: SlideUpTransitionAnimator?
    fileprivate var style : Style!
    
    func start(_ dependencies: HasNavigationController & HasStoryboard & HasGoalDataStore & HasStyle, goal: Goal?) {
        
        self.presentingNavController = dependencies.navigationController
        self.storyboard = dependencies.storyboard
        self.style = dependencies.style
        
        let interactor = GoalDetailFactory.interactor(goalDataStore: dependencies.goalDataStore)
        var presenter = GoalDetailFactory.presenter(goal: goal, interactor: interactor, wireframe: self)
        
        let viewController: GoalDetailViewController = storyboard.viewController()
        viewController.presenter = presenter
        viewController.style = dependencies.style
        presenter.delegate = viewController
        
        let navCtrl = UINavigationController(navigationBarClass: MFLCommon.shared.navigationBarClassLight, toolbarClass: nil)
        navCtrl.viewControllers = [viewController]
        navCtrl.modalPresentationStyle = .custom
        
        transitioningDelegate = SlideUpTransitionAnimator()
        navCtrl.transitioningDelegate = transitioningDelegate
        
        if let goal = goal {
            viewController.title = NSLocalizedString("Goal", comment: "")
            
            if goal.isExample {
                let exampleBannerView = ExampleBannerView()
                exampleBannerView.style = dependencies.style
                exampleBannerView.frame = CGRect(x: navCtrl.view.bounds.maxX - exampleBannerView.frame.width, y: 0, width: exampleBannerView.frame.width, height: exampleBannerView.frame.height)
                navCtrl.view.addSubview(exampleBannerView)
            }
        } else {
            viewController.title = NSLocalizedString("New Goal", comment: "")
        }
        
        presentingNavController.present(navCtrl, animated: true, completion: nil)
    }
    
    func dismiss() {
        MFLAnalytics.record(event: .buttonTap(name: "Well Done Screen - OK Tapped", value: nil))
        presentingNavController.dismiss(animated: true, completion: nil)
    }
    
    func showGoalComplete() {
        let viewController: CompletedGoalViewController = storyboard.viewController()
        viewController.style = style
        viewController.modalTransitionStyle = .crossDissolve
        viewController.dismiss = { [unowned self] in self.dismiss() }
        presentingNavController.dismiss(animated: true) {
            self.presentingNavController.present(viewController, animated: true, completion: nil)
        }
    }
}
