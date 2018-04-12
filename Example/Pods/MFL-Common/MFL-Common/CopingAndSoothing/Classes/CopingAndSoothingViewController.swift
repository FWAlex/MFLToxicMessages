//
//  CopingAndSoothingViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 23/10/2017.
//
//

import UIKit
import PKHUD

class CopingAndSoothingViewController: MFLViewController {
    
    var presenter : CopingAndSoothingPresenter!
    var style : Style!
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var imageView : UIImageView!

    private lazy var editBarButton : UIBarButtonItem = { return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit(_:))) }()
    
    var mode : CopingAndSoothingMode! {
        didSet {
            let imageName = mode == .doMore ? "coping_and_soothing_doMore" : "coping_and_soothing_doLess"
            imageView.image = UIImage(named: imageName, bundle: .app)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode = .doMore
        
        navigationItem.rightBarButtonItem = editBarButton
        
        gradientLayerColors = style.gradient
        shouldUseGradientBackground = true
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 78
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewDidAppear()
    }
    
    @IBAction func didSelectMode(_ sender: UISegmentedControl) {
        mode = sender.selectedSegmentIndex == 0 ? .doMore : .doLess
    }
    
    @objc func didTapEdit(_ sender: Any) {
        presenter.userWantsToEdit(mode)
    }
}

//MARK: - UITableViewDataSource
extension CopingAndSoothingViewController : UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemsCount(for: mode)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CopingAndSoothingCell, indexPath: indexPath)
        cell.isBubbleHidden = indexPath.row == 0
        if cell.style == nil { cell.style = style }
        cell.body = presenter.bodyForItem(at: indexPath.row, mode: mode)
        
        return cell
    }
}

extension  CopingAndSoothingViewController : CopingAndSoothingPresenterDelegate {
    func copingAndSoothingPresenter(_ sender: CopingAndSoothingPresenter, wantsToPresentActivity inProgress: Bool) {
        if inProgress { HUD.show(.progress) }
        else { HUD.hide() }
    }
    
    func copingAndSoothingPresenter(_ sender: CopingAndSoothingPresenter, wantsToPresent error: Error) {
        showAlert(for: error)
    }
    
    func copingAndSoothingPresenterWantsToUpdateActivities(_ sender: CopingAndSoothingPresenter) {
        tableView.reloadData()
    }
}

