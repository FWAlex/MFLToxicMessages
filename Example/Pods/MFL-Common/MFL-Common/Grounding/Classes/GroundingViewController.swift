//
//  GroundingViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 26/09/2017.
//
//

import UIKit

class GroundingViewController: MFLViewController {
    
    var presenter : GroundingPresenter!
    var style : Style!

    @IBOutlet weak var groundingScrollView: GroundingScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    override func viewDidLoad() {

        gradientLayerColors = style.gradient
        shouldUseGradientBackground = true
        
        let items = presenter.groundingItems(with: style)
        pageControll.numberOfPages = items.count
        groundingScrollView.set(items: items)
        
        groundingScrollView.delegate = self
    }
}


extension GroundingViewController : GroundingPresenterDelegate {
    
}

extension GroundingViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControll.currentPage = scrollView.horizontalPage
    }
}
