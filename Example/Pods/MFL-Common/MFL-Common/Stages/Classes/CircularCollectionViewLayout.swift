//
//  StagesViewController.swift
//  MFLRecovery
//
//  Created by Marc Blasi on 10/08/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//


import UIKit

class CircularCollectionViewLayout: UICollectionViewFlowLayout {
    
    /**
     *  The items in the collection view are following the trajectory of the upper half of an elipse.
     *  The center if the elipse is the point (collectionView.width/2, collectionView.height).
     *  The xRadius is equal to collectionView.width/2 + xRadiusInset.
     *  The xRadiusInset by default is equal to 0.
     */
    var xRadiusInset = CGFloat(50.0) { didSet { invalidateLayout() } }
    
    /**
     *  The items in the collection view are following the trajectory of the upper half of an elipse.
     *  The center if the elipse is the point (collectionView.width/2, collectionView.height).
     *  The yRadius is equal to collectionView.width + yRadiusInset.
     *  The yRadiusInset by default is equal to 0.
     */
    var yRadiusInset = CGFloat(0.0) { didSet { invalidateLayout() } }
    
    /**
     *  The scale the items will have in the top most position, in the center of the collection view.
     *  Only one item can reach this scale at a time. We consider this item to be in focus.
     *  By default this is equal to 1.0
     */
    var maxScale = CGFloat(1.0) { didSet { invalidateLayout() } }
    
    /**
     *  The scale the items will have in the left most or right most position.
     *  By default this is equal to 0.5
     */
    var minScale = CGFloat(0.5) { didSet { invalidateLayout() } }
    
    /**
     *  The spacing between the items.
     */
    var spacing = CGFloat(0.0) { didSet { invalidateLayout() } }
    
    fileprivate var xRadius : CGFloat {
        return (collectionView?.bounds.width ?? 0.0) / 2 + xRadiusInset
    }
    
    fileprivate var yRadius : CGFloat {
        return (collectionView?.bounds.height ?? 0.0) + yRadiusInset
    }
    
    fileprivate var attributesCash = [UICollectionViewLayoutAttributes]()
    fileprivate var shouldSnap: Bool
    
    fileprivate var cellCount: Int {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.numberOfSections > 0 ? collectionView.numberOfItems(inSection: 0) : 0
    }
    
    fileprivate var currentOffsetIndex : Int {
        guard let collectionView = collectionView else { return 0 }
        return index(for: collectionView.contentOffset.x)
    }
    
    var selectedItem: Int?
    
    init(itemSize: CGSize, shouldSnap: Bool = true) {
        self.shouldSnap = shouldSnap
        
        super.init()
        
        self.itemSize = itemSize
        self.scrollDirection = .horizontal
        self.sectionInset = .zero
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttibutes = [UICollectionViewLayoutAttributes]()
        
        for (index, attribute) in attributesCash.enumerated() {
            updateFrameForItem(at: index)
            layoutAttibutes.append(attribute)

            if rect.intersects(attribute.frame) {
                updateFrameForItem(at: index)
                layoutAttibutes.append(attribute)
            }
        }
        return layoutAttibutes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        updateFrameForItem(at: indexPath.item)
        return attributesCash[indexPath.item]
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if self.shouldSnap {
            let index = self.index(for: proposedContentOffset.x)
            let off = Int(proposedContentOffset.x) % Int(self.itemSize.width + spacing)

            let targetX = (CGFloat(off) > self.itemSize.width * 0.5 && index <= self.cellCount) ? (CGFloat(index+1) * (self.itemSize.width + spacing)) : (CGFloat(index) * (self.itemSize.width + spacing))

            return CGPoint(x: targetX, y: proposedContentOffset.y)
        }
        else {
            return proposedContentOffset
        }
    }
    
    override func targetIndexPath(forInteractivelyMovingItem previousIndexPath: IndexPath, withPosition position: CGPoint) -> IndexPath {
        return IndexPath(row: 0, section: 0)
    }

    override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
       
        attributesCash = [UICollectionViewLayoutAttributes]()
        (0 ..< cellCount).forEach {
            let attribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: $0, section: 0))
            let x = xForItem(at: $0)
            attribute.frame = CGRect(origin: CGPoint(x: x, y: 0.0),
                                     size: itemSize)
            attributesCash.append(attribute)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        let widthContentSize = CGFloat(self.cellCount - 1) * (self.itemSize.width + spacing) + self.collectionView!.bounds.size.width
        return CGSize(width: widthContentSize, height: self.collectionView!.bounds.size.height)
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
}

//MARK: - Helper
fileprivate extension CircularCollectionViewLayout {
    
    func xForItem(at index: Int) -> CGFloat {
        guard let collectionView = collectionView else { return 0.0 }
        return collectionView.width / 2 + index.cgFloat * (itemSize.width + spacing) - itemSize.width / 2
    }
    
    func yForItem(at index: Int) -> CGFloat {
        guard let collectionView = collectionView else { return 0.0 }
        
        // The items will scroll in a circular motion from one lower corner of the collection view to the center top
        // and the back to the opposite lower corner. Something like this but in a circlular motion: /\
        // This means that the items will follow the trajectory of the upper half of an elipse.
        // So we will map the y of the item using the content offset X (mapped to origin) of the collection view and the
        // equation of an elipse with it's center in the orgigin: x^2 / xRadius^2 + y^2 / yRadius^2 = 1
        
        // We then map the content offset X for the item at the current index to origin.
        let xForIndex = xMappedToOrigin(for: index)
        
        
        // We extract y^2 from the elipse formula
        let ySquare = (yRadius ^ 2.0)  * (1 - ((xForIndex / xRadius) ^ 2.0))
        
        // We disregard the case where y^2 is negative for two reasons:
        //      1. If y^2 is negative this means that the item should be displayed in the lower half of the
        //         elipse and we disregard these cases.
        //      2. We need to find y so we need to apply sqrt, but sqrt is not defined on negaive values.
        // We substract sqrt(y^2) from the collectionView height because the origin of the collection view is in the top left corner
        // and the math is all done in the normal coordinate system so we need to map y to the collection view.
        let y = ySquare > 0 ? collectionView.height - sqrt(ySquare) : collectionView.bounds.height

//        if index == 0 { print("\(xForIndex)     \(ySquare)      \(y)") }
        
        return y
    }
    
    func scaleFactorForItem(at index: Int) -> CGFloat {
        let xForIndex = abs(xMappedToOrigin(for: index))
        let cappedPosition = max(0.0, min(1.0, xForIndex / xRadius))
        let scaleFactor = maxScale - cappedPosition * (maxScale - minScale)
        
        return scaleFactor
    }
    
    func index(for offset: CGFloat) -> Int {
        return Int(floor(offset / (self.itemSize.width + spacing)))
    }
    
    func xMappedToOrigin(for index: Int) -> CGFloat {
        guard let collectionView = collectionView else { return 0.0 }
        return collectionView.contentOffset.x - index.cgFloat * (itemSize.width + spacing)
    }
    
    /**
     *  We apply all the transforms on the layout attribute manually at once.
     *
     *  This is done because when applying them separately or by using a CGAffineTransform
     *  we get UI glitches when scrolling.
     */
    
    func updateFrameForItem(at index: Int) {
        
        let scaleFactor = scaleFactorForItem(at: index)
        
        var frame = CGRect()
        frame.origin.y = yForItem(at: index)
        frame.size.width = itemSize.width * scaleFactor
        frame.size.height = itemSize.height * scaleFactor
        
        // This will sure that the items will tend to stock together regardless of their scale
//        let multiplier : CGFloat = xMappedToOrigin(for: index) > 0 ? 1.0 : 0.0
//        frame.origin.x = xForItem(at: index) + multiplier * (itemSize.width - frame.size.width)
        frame.origin.x = xForItem(at: index) + (itemSize.width - frame.size.width) / 2
        
        let attributes = attributesCash[index]
        attributes.frame = frame
    }
}

fileprivate func ^(_ lhs: CGFloat, _ rhs: CGFloat) -> CGFloat {
    return pow(lhs, rhs)
}
