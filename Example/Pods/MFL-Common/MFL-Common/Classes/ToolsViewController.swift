//
//  ToolsViewController.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 11/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import MFL_Common

class ToolsViewController: MFLViewController {
    
    var presenter : ToolsPresenter!
    var cellFactory : CellFactory!
    var style : Style!
    @IBOutlet var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfoView(style)
        self.cellFactory = CellFactory(container: self.collectionView!)
        self.collectionView?.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        self.gradientLayerColors = style.gradient
        self.gradientStartPoint = CGPoint(x: 0.25, y: 0.0)
        self.gradientEndPoint = CGPoint(x: 0.75, y: 1.0)
        self.shouldUseGradientBackground = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(subscriptionDidFinish), name: MFLSubscriptionDidFinish, object: nil)
    }
    
    @objc fileprivate func subscriptionDidFinish() {
        // After a small delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            [weak self] in
            self?.reload()
        }
    }
}

extension ToolsViewController {
    func reload() {
        self.collectionView?.reloadData()
    }
}

extension ToolsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.sectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfEntries(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellFactory.dequeueReusableCell(ToolsCollectionViewCell.self, at: indexPath, in: .common)
        let cellData = self.presenter.toolsEntry(at: indexPath)
        cell.style = style
        cell.configure(with: cellData)
        return cell
    }
}

extension ToolsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.openTool(index: indexPath.row)
    }
}

extension ToolsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = self.view.frame.width / 2
        let title = self.presenter.toolsEntry(at: indexPath).title
        
        return ToolsCollectionViewCell.size(with: title, constrainedTo: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension ToolsViewController : ToolsPresenterDelegate {
    func toolsPresenter(_ sender: ToolsPresenter,
                        wantsToShowInfo text: String?,
                        button: String?,
                        action: (() -> Void)?) {

        guard isViewLoaded else { return } // this is to prevent crash if infoView is not initialised while notification coming from QuestionirieTracker. Cause: InfoView is implemeted in parent class (MFLViewController).

        guard let text = text else {
            hideInfoView()
            return
        }
        
        setInfo(text: text, buttonTitle: button, action: action, image: nil, isDismissable: false)
        showInfoView()
    }
}
