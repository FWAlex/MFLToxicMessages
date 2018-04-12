//
//  StepDetailCell.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 16/02/2018.
//

import UIKit

final class StepDetailCell: UICollectionViewCell, Reusable, NibInstantiable {

    var style : Style? { didSet { updateUI() } }
    var data : StagesStepViewData? { didSet { updateUI() } }
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var detailLabel: UILabel!
    
    fileprivate let titleTextStyle = TextStyle.bigTitle
    fileprivate let detailTextStyle = TextStyle.smallTitle
    
    func updateUI() {
        titleLabel.attributedText = titleTextStyle.attributedString(with: data?.title,
                                                                    color: style?.textColor4 ?? .white)
        detailLabel.attributedText = detailTextStyle.attributedString(with: data?.detail,
                                                                      color: style?.textColor4 ?? .white)
    }
}
