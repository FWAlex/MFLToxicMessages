//
//  FinkelhorBehaviourViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 05/12/2017.
//
//

import UIKit

class FinkelhorBehaviourViewController: MFLViewController {
    
    var presenter : FinkelhorBehaviourPresenter!
    var style : Style!
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var headerLabel: UILabel!
    @IBOutlet fileprivate weak var headerView: UIView!
    
    fileprivate var headerTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium),
                                                lineHeight: 30)
    fileprivate let headerTextPadding = CGFloat(40.0)
    fileprivate let sectionHeaderFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        applyStyle()
        setUpTableView()
    }
    
    fileprivate func applyStyle() {
        headerLabel.attributedText = headerLabel.text?.attributedString(style: headerTextStyle,
                                                                        color: style.textColor1,
                                                                        alignment: .center)
        let height = headerLabel.attributedText!.height(constraintTo: headerLabel.width)
        headerView.frame.size.height = 2 * headerTextPadding + height
    }
    
    fileprivate func setUpTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 98
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()
    }
}

extension FinkelhorBehaviourViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(FinkelhorBehavioursCell, indexPath: indexPath)
        if cell.style == nil { cell.style = style }
        cell.data = presenter.behaviour(at: indexPath)
        cell.action = { self.presenter.set($0, forItemAt: indexPath) }
        
        return cell
    }
}

extension FinkelhorBehaviourViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let name = presenter.sectionName(at: section)
        
        let view = UIView()
        view.backgroundColor = style.textColor3
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 4.0).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4.0).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        
        label.text = name.uppercased()
        label.textColor = style.textColor2
        label.font = sectionHeaderFont
        
        return view
    }
}

extension FinkelhorBehaviourViewController : FinkelhorBehaviourPresenterDelegate {
    
}

