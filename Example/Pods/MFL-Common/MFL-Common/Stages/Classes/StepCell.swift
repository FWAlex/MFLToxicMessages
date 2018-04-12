//
//  StepCell.swift
//  MFL-Common
//
//  Created by Marc Blasi on 25/09/2017.
//

import UIKit
import MFL_Common

final class StepCell: UICollectionViewCell, Reusable, NibInstantiable {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with data: StagesStepViewData) {
        self.imageView.image = UIImage(named: data.imageName, bundle: .stages)
    }
}
