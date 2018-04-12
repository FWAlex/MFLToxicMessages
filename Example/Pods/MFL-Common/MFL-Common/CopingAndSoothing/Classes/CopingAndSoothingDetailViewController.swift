//
//  CopingAndSoothingDetailViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 26/10/2017.
//
//

import UIKit
import PKHUD

class CopingAndSoothingDetailViewController: MFLViewController {
    
    var presenter : CopingAndSoothingDetailPresenter!
    var style : Style!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var closeBarButton : UIBarButtonItem = {
        
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
        let image = UIImage.template(named: "close_white", in: .common)
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = self.style.primary
        button.sizeToFit()
        
        return UIBarButtonItem(customView: button)
    }()
    
    lazy var finishButton : UIBarButtonItem = {
        return UIBarButtonItem(title: self.presenter.barButtonText, style: .plain, target: self, action: #selector(didTapFinish(_:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarStyle = .default
        
        navigationItem.leftBarButtonItem = presenter.shouldShowCloseButton ? closeBarButton : nil
        navigationItem.rightBarButtonItem = finishButton

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    @IBAction func didTapClose(_ sener: Any) {
        presenter.userWantsToClose()
    }
    
    @IBAction func didTapFinish(_ sender: Any) {
        presenter.userWantsToFinish()
    }
}

extension CopingAndSoothingDetailViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1: return 1
        default: return presenter.itemsCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(CopingAndSoothingDetailAddCell.self, indexPath: indexPath)
            if cell.style == nil { cell.style = style }
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(CopingAndSoothingDetailHeaderCell.self, indexPath: indexPath)
            if cell.style == nil { cell.style = style }
            cell.header = presenter.header
            return cell
        default:
            let cell = tableView.dequeueReusableCell(CopingAndSoothingDetailCell.self, indexPath: indexPath)
            if cell.style == nil { cell.style = style }
            cell.item = presenter.item(at: indexPath.row)
            return cell
        }
    }
}

extension CopingAndSoothingDetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.userDidSelectItem(at: indexPath.row)
    }
}

extension CopingAndSoothingDetailViewController : CopingAndSoothingDetailPresenterDelegate {
    
    func copingAndSoothingDetailPresenterWantsToRefreshItems(_ sender: CopingAndSoothingDetailPresenter) {
        tableView.reloadData()
    }
    
    func copingAndSoothingDetailPresenter(_ sender: CopingAndSoothingDetailPresenter, wantsToShowActivity inProgress: Bool) {
        if inProgress { HUD.show(.progress) }
        else { HUD.hide() }
    }
    
    func copingAndSoothingDetailPresenter(_ sender: CopingAndSoothingDetailPresenter, wantsToPresent error: Error) {
        showAlert(for: error)
    }
    
    func copingAndSoothingDetailPresenter(_ sender: CopingAndSoothingDetailPresenter, didAddNewItemAt index: Int) {
        let newIndexPath = IndexPath(row: index, section: 2)
        tableView.beginUpdates()
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.endUpdates()
        tableView.scrollToRow(at: newIndexPath, at: .none, animated: true)
    }
    
    func copingAndSoothingDetailPresenter(_ sender: CopingAndSoothingDetailPresenter, didAddUpdateItemAt index: Int) {
        let indexPath = IndexPath(row: index, section: 2)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}

extension CopingAndSoothingDetailViewController : CopingAndSoothingDetailAddCellDelegate {
    func addCell(_ sender: CopingAndSoothingDetailAddCell, wantsToAdd text: String) {
        presenter.userWantsToAdd(text)
    }
}

