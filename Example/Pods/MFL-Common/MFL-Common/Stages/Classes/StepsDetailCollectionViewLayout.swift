//
//  StepsDetailCollectionViewLayout.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 16/02/2018.
//

import UIKit

class StepsDetailCollectionViewLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        
        scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let width = collectionView.numberOfItems(inSection: 0).cgFloat * collectionView.bounds.size.width
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.layoutAttributesForItem(at: indexPath)
        
        if let collectionView = collectionView, let attributes = attributes {
            let x = indexPath.item.cgFloat * collectionView.bounds.width
            attributes.frame = CGRect(origin: CGPoint(x: x, y: 0.0),
                                      size: collectionView.bounds.size)
        }
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        var attributesToReturn = [UICollectionViewLayoutAttributes]()
        
        for i in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let attributes = layoutAttributesForItem(at: IndexPath(item: i, section: 0))
            if let attributes = attributes, attributes.frame.intersects(rect) {
                attributesToReturn.append(attributes)
            }
        }
        
        return attributesToReturn
    }
}
