//
//  FinkelhorViewController.swift
//  Pods
//
//  Created by Alex Miculescu on 27/11/2017.
//
//

import UIKit

class FinkelhorViewController: MFLViewController {
    
    var presenter : FinkelhorPresenter!
    var style : Style!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeaderLabel: UILabel!
    
    private let headerLabelTextStyle = TextStyle(font: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium), lineHeight: 30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayerColors = style.gradient
        shouldUseGradientBackground = true
        
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.bounces = false
        
        applyStyle()
    }
    
    func applyStyle() {
        tableViewHeaderLabel.attributedText = tableViewHeaderLabel.text?.attributedString(style: headerLabelTextStyle,
                                                                                          color: style.textColor4,
                                                                                          alignment: .center)
    }
}

extension FinkelhorViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(FinkelhorCell.self, indexPath: indexPath)
        
        if cell.style == nil { cell.style = style }
        cell.action = presenter.actionForItem(at: indexPath.row)
        cell.name = presenter.nameForItem(at: indexPath.row)
        
        return cell
    }
}

extension  FinkelhorViewController : FinkelhorPresenterDelegate {
    
}

