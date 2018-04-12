//
//  MFLCustomChatFlowLayout.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 31/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class MFLCustomChatFlowLayout : UICollectionViewFlowLayout {
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attr = super.layoutAttributesForItem(at: itemIndexPath)?.copy() as? UICollectionViewLayoutAttributes
        
        if let collectionView = collectionView {
            
            let height = max(collectionView.contentSize.height, collectionView.bounds.height)
            attr?.frame.origin.y = height + collectionView.contentInset.bottom
        }
        
        return attr;
    }
}
