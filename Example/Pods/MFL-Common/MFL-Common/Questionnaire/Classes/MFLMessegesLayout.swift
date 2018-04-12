//
//  MFLMessegesLayout.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 23/03/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit
import FW_JSQMessagesViewController


protocol MFLMessegesLayoutDelegate : class {
    func mfl_messegesLayout(_ sender: MFLMessegesLayout, typeForItemAt indexPath: IndexPath) -> MFLMessageType
}

class MFLMessegesLayout: JSQMessagesCollectionViewFlowLayout {
    
    weak var mfl_delegate : MFLMessegesLayoutDelegate?
    
    override var minimumLineSpacing: CGFloat {
        get { return CGFloat(12.0) }
        set { super.minimumLineSpacing = newValue }
    }
    
    override var messageBubbleFont: UIFont {
        get { return UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightMedium) }
        set { super.messageBubbleFont = newValue }
    }
    
    override var messageBubbleLeftRightMargin: CGFloat {
        get { return 16.0 }
        set { super.messageBubbleLeftRightMargin = newValue }
    }
    
    override var messageBubbleTextViewFrameInsets: UIEdgeInsets {
        get {
            var insets = super.messageBubbleTextViewFrameInsets
            insets.top = 10.0
            insets.bottom = 10.0
            
            return insets
        }
        set { super.messageBubbleTextViewFrameInsets = newValue }
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attr = super.layoutAttributesForItem(at: itemIndexPath)
        
        if let delegate = mfl_delegate {
            
            switch delegate.mfl_messegesLayout(self, typeForItemAt: itemIndexPath) {
            case .outgoing:
                attr?.frame.origin.x = collectionView.bounds.size.width
            case .incoming:
                attr?.frame.origin.x = -collectionView.bounds.size.width
            }
            
        } else {
            attr?.alpha = 0.0
            attr?.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        
        return attr;
    }
    
    
}
