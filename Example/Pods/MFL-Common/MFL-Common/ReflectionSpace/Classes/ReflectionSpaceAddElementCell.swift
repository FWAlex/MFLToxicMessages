//
//  ReflectionSpaceAddElementCell.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 06/02/2018.
//

import UIKit

class ReflectionSpaceAddElementCell : UICollectionViewCell, Identifiable {
    
    @IBOutlet private weak var addButtonView: ReflectionSpaceAddButton!
    @IBOutlet private weak var containerView: RoundedView!
    
    typealias ReflectionSpaceAddElementCellAction = () -> Void
    var style : Style? { didSet { updateStyle() } }
    var action : ReflectionSpaceAddElementCellAction? { didSet { addButtonView.action = action } }
    
    private func updateStyle() {
        addButtonView.style = style
        containerView.backgroundColor = style?.textColor4.withAlphaComponent(0.2)
    }
}
