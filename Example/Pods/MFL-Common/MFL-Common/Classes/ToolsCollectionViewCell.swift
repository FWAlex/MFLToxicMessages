//
//  ToolsCollectionViewCell.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 11/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import AlamofireImage

fileprivate let imageHeight = CGFloat(100)
fileprivate let titleTextStyle = TextStyle(font: .systemFont(ofSize: 21, weight: UIFontWeightMedium), lineHeight: 26)

final class ToolsCollectionViewCell: UICollectionViewCell, Reusable, NibInstantiable {
    struct CellData {
        let imageName: String
        let title: String
    }
    
    var style : Style?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
    }
    
    func configure(with data: CellData) {
        
        self.imageView.image = UIImage(named: data.imageName, bundle: MFLCommon.shared.appBundle)
        self.titleLabel.attributedText = data.title.attributedString(style: titleTextStyle,
                                                                     color: style != nil ? style!.textColor4 : .white,
                                                                     alignment: .center)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
        self.imageView.af_cancelImageRequest()
        
        self.titleLabel.text = nil
    }
    
    static func size(with title: String, constrainedTo width: CGFloat) -> CGSize {
        
        var height = imageHeight - 8
        
        let attributedTitle = title.attributedString(style: titleTextStyle, alignment: .center)
        
        height += attributedTitle.height(constraintTo: width)
        
        return CGSize(width: width, height: height)
    }
}
