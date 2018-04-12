//
//  ReflectionSpaceLayout.swift
//  MFL-Common
//
//  Created by Alex Miculescu on 05/10/2017.
//

import UIKit

protocol ReflectionSpaceLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath, toFit width: CGFloat) -> CGFloat
}

private enum Sections : Int {
    case addButtton = 0
    case elements = 1
}

class ReflectionSpaceLayout : UICollectionViewFlowLayout {

    weak var delegate: ReflectionSpaceLayoutDelegate!
    
    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 6
    
    fileprivate var addItemAttributes : UICollectionViewLayoutAttributes!
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    fileprivate var columnWidth = CGFloat(0.0)
    fileprivate var xOffset = [CGFloat]()
    fileprivate var yOffset = [CGFloat]()
    fileprivate lazy var attributesForHeader : UICollectionViewLayoutAttributes = {
        return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                                with: IndexPath(row: 0, section: Sections.addButtton.rawValue))
    }()
    
    fileprivate lazy var zeroFrameHeaderAttributes : UICollectionViewLayoutAttributes = {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                                          with: IndexPath(row: 0, section: Sections.elements.rawValue))
        attributes.frame = .zero
        return attributes
    }()
    
    var shouldForcePrepare : Bool = false
    
    override func prepare() {
        
        guard (cache.isEmpty == true || shouldForcePrepare), let collectionView = collectionView else {
            return
        }
        
        shouldForcePrepare = false
        
        cache = [UICollectionViewLayoutAttributes]()
        contentHeight = 0.0
        
        attributesForHeader.frame = CGRect(origin: CGPoint.zero, size: ReflectionSpaceHeader.size(for: contentWidth))
        
        columnWidth = contentWidth / CGFloat(numberOfColumns)
        xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        yOffset = [CGFloat](repeating: attributesForHeader.frame.height, count: numberOfColumns)
        
        // The first elemet is the plus (add image) button. It has a aspect ration of 1:1
        // so the yOffset of the first column starts at columnWidth
        addItemAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: 0, section: Sections.addButtton.rawValue))
        addItemAttributes.frame = CGRect(x: 0.0, y: yOffset[0], width: columnWidth, height: columnWidth)
        
        yOffset[0] += columnWidth
        
        var column = 1
        
        for item in 0 ..< collectionView.numberOfItems(inSection: Sections.elements.rawValue) {
            let indexPath = IndexPath(item: item, section: Sections.elements.rawValue)
            calculateAttribute(forItemAt: indexPath, in: column)
            column = columnWithMinYOffset(from: yOffset)
        }
    }
    
    func columnWithMinYOffset(from yOffset: [CGFloat]) -> Int {
        var min = yOffset[0]
        var columnToReturn = 0
        for column in 1 ..< numberOfColumns {
            if yOffset[column] < min {
                min = yOffset[column]
                columnToReturn = column
            }
        }
        
        return columnToReturn
    }
    
    func calculateAttribute(forItemAt indexPath: IndexPath, in column: Int) {
        
        guard let collectionView = collectionView else { return }
        
        let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath, toFit: columnWidth)
        let height = cellPadding * 2 + photoHeight
        let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        
        contentHeight = max(contentHeight, frame.maxY)
        yOffset[column] = yOffset[column] + height
    }
    
    func newItemsAdded(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let column = columnWithMinYOffset(from: yOffset)
            calculateAttribute(forItemAt: indexPath, in: column)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        if attributesForHeader.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributesForHeader)
        }
        
        if addItemAttributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(addItemAttributes)
        }
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section == Sections.addButtton.rawValue { return addItemAttributes }
        return cache[indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section == Sections.addButtton.rawValue { return attributesForHeader }
        return zeroFrameHeaderAttributes
    }
}
