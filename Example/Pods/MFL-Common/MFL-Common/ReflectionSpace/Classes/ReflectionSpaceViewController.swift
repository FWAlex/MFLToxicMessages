//
//  ReflectionSpaceViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 03/10/2017.
//
//

import UIKit
import PKHUD

private enum Sections : Int {
    case addButton = 0
    case elements = 1
    
    static let count = 2
}

class ReflectionSpaceViewController: MFLViewController {
    
    var presenter : ReflectionSpacePresenter!
    var style : Style!
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet weak var addImageView: ReflectionSpaceAddButton!
    
    fileprivate let noContentTitleStyle = TextStyle(font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium), lineHeight: 30)
    fileprivate let noContentSubtitleStyle = TextStyle(font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium), lineHeight: 24)
    
    fileprivate var noContentGradientLayer : CAGradientLayer!
    @IBOutlet weak var noContentTitleLabel: UILabel!
    @IBOutlet weak var noContentSubtitleLabel: UILabel!
    @IBOutlet weak var noContentView: UIView!
    
    fileprivate lazy var labelBarButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "0 " + NSLocalizedString("Selected", comment: ""), style: .plain, target: nil, action: nil)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addImageView.action = { [weak self] in self?.addTapped() }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "ReflectionSpaceHeader", bundle: .reflectionSpace), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        if let layout = collectionView.collectionViewLayout as? ReflectionSpaceLayout {
            layout.delegate = self
        }
        
        applyStyle()
        presenter.viewDidLoad()
        
        let delBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(ReflectionSpaceViewController.deleteTapped(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [labelBarButton, space, delBtn]
        
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    @objc func deleteTapped(_ sender: Any) {
        presenter.userWantsToDeleteSelectedItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let value =  UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    fileprivate func applyStyle() {
        navigationController?.toolbar.tintColor = style.primary
        
        addImageView.style = style
        
        self.gradientLayerColors = style.gradient
        self.gradientStartPoint = CGPoint(x: 0.25, y: 0.0)
        self.gradientEndPoint = CGPoint(x: 0.75, y: 1.0)
        self.shouldUseGradientBackground = true
        
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController?.tabBar.frame.height ?? 0, right: 0)
        
        noContentView.backgroundColor = .clear
        
        noContentTitleLabel.attributedText = noContentTitleLabel.text?.attributedString(style: noContentTitleStyle,
                                                                                        color: style.textColor4,
                                                                                        alignment: .center)
        
        noContentSubtitleLabel.attributedText = noContentSubtitleLabel.text?.attributedString(style: noContentSubtitleStyle,
                                                                                              color: style.textColor4,
                                                                                              alignment: .center)
    }
    
    @objc fileprivate func addTapped() {
        presenter.userWantsToAdd()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if !editing {
            presenter.deselectAllItems()
            navigationController?.setToolbarHidden(true, animated: true)
        }
        
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDataSource
extension ReflectionSpaceViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == Sections.addButton.rawValue { return 1 }
        return presenter.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell
        
        if indexPath.section == Sections.addButton.rawValue {
            let addButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReflectionSpaceAddElementCell.identifier, for: indexPath as IndexPath) as! ReflectionSpaceAddElementCell
            if addButtonCell.style == nil { addButtonCell.style = style }
            addButtonCell.action = { [weak self] in self?.addTapped() }
            
            cell = addButtonCell
        
        } else {
            let elementCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReflectionSpaceItemCell", for: indexPath as IndexPath) as! ReflectionSpaceItemCell
            if elementCell.style == nil { elementCell.style = style }
            elementCell.item = presenter.item(at: indexPath.item)
            elementCell.isSelectable = isEditing
            elementCell.setSelected(presenter.isSelectedItem(at: indexPath.row), animated: false)
            
            cell = elementCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "Header",
                                                                         for: indexPath) as! ReflectionSpaceHeader
        
        if headerView.style == nil { headerView.style = style }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return ReflectionSpaceHeader.size(for: collectionView.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditing {
            presenter.userSelectedItem(at: indexPath.row)
            collectionView.reloadItems(at: [indexPath])
        }
        else { presenter.userWantsToViewItem(at: indexPath.item) }
    }
}


//MARK: - ReflectionSpaceLayoutDelegate
extension ReflectionSpaceViewController : ReflectionSpaceLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, toFit width: CGFloat) -> CGFloat {
        return presenter.heightForItem(at: indexPath.row, toFit: width)
    }
}

extension ReflectionSpaceViewController : ReflectionSpacePresenterDelegate {
    
    func reflectionSpacePresenterWantsToReload(_ sender: ReflectionSpacePresenter) {
        collectionView.reloadData()
        collectionView.scrollRectToVisible(CGRect(x: 0, y: self.collectionView.contentSize.height, width: self.collectionView.width, height: 1), animated: true)
    }
    
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, wantsToShow alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, wantsToSetEmptyState visible: Bool) {
        noContentView.isHidden = !visible
        collectionView.isHidden = visible
        navigationItem.rightBarButtonItem = visible ? nil : editButtonItem
        
        if visible {
            setEditing(false, animated: false)
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, wantsToShowActivity inProgress: Bool) {
        if inProgress { HUD.show(.progress) }
        else { HUD.hide() }
    }
    
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, didAddNewItems count: Int) {
        
        var indexPaths = [IndexPath]()
        let startIndex = presenter.numberOfItems - count
        let endIndex = startIndex + count
        
        for i in startIndex..<endIndex {
            indexPaths.append(IndexPath(row: i, section: Sections.elements.rawValue))
        }
        
        if let layout = collectionView.collectionViewLayout as? ReflectionSpaceLayout {
            layout.newItemsAdded(at: indexPaths)
        }
        
        collectionView.performBatchUpdates({
            self.collectionView.insertItems(at: indexPaths)
        }, completion: { _ in
            self.collectionView.scrollRectToVisible(CGRect(x: 0, y: self.collectionView.contentSize.height, width: self.collectionView.width, height: 1), animated: true)
        })
    }
    
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, didDeleteItemsAt indexes: [Int]) {
        let indexPaths = indexes.map { IndexPath(row: $0, section: Sections.elements.rawValue) }
        
        if let layout = collectionView.collectionViewLayout as? ReflectionSpaceLayout {
            layout.shouldForcePrepare = true
        }
        
        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: indexPaths)
        }, completion: nil)
    }
    
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, wantsToAllowItemDeletion isDeletionAllowed: Bool) {
        navigationController?.setToolbarHidden(!(isEditing && isDeletionAllowed), animated: true)
    }
    
    func reflectionSpacePresenter(_ sender: ReflectionSpacePresenter, didUpdateSelectedItemsCount count: Int) {
        labelBarButton.title = "\(count) " + NSLocalizedString("Selected", comment: "")
    }
}

