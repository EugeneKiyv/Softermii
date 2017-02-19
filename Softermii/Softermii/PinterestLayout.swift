//
//  PinterestLayout.swift
//  Softermii
//
//  Created by Eugene Kuropatenko on 2/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
    func heightForImageAtIndexPath(_ collectionView : UICollectionView,
                                   indexPath : IndexPath,
                                   width : CGFloat
        ) -> CGFloat
    func heightForBodyAtIndexPath(_ collectionView : UICollectionView,
                                  indexPath : IndexPath,
                                  width : CGFloat
        ) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
    
    var delegate: PinterestLayoutDelegate! = nil
    
    var cachedAttributes : Array<UICollectionViewLayoutAttributes> = [];
    
    var contentHeight : CGFloat = 0.0
    
    let kNumberOfColumns : Int = 2
    let kCellMargin : CGFloat = 10.0
    
    func contentWidth() -> CGFloat {
        return self.collectionView!.bounds.width - (self.collectionView!.contentInset.left + self.collectionView!.contentInset.right)
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: self.contentWidth(), height: self.contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes : Array<UICollectionViewLayoutAttributes> = []
        
        for attribute in self.cachedAttributes {
            if (attribute.frame.intersects(rect)) {
                layoutAttributes.append(attribute)
            }
        }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cachedAttributes[indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override func prepare() {
        if self.cachedAttributes.count > 0 {
            return;
        }
        
        var column : Int = 0
        
        let totalHorizontalMargin : CGFloat = (kCellMargin * (CGFloat(kNumberOfColumns - 1)))
        let cellWidth : CGFloat = (self.contentWidth() - totalHorizontalMargin) / CGFloat(kNumberOfColumns)
        
        var cellOriginXList : Array<CGFloat> = Array<CGFloat>()
        for i in 0..<kNumberOfColumns {
            let originX : CGFloat  = CGFloat(i) * (cellWidth + kCellMargin)
            cellOriginXList.append(originX)
        }
        
        var currentCellOriginYList : Array<CGFloat> = Array<CGFloat>()
        for _ in 0..<kNumberOfColumns {
            currentCellOriginYList.append(0.0)
        }
        
        for item in 0..<self.collectionView!.numberOfItems(inSection: 0) {
            let indexPath : IndexPath = IndexPath(row: item, section: 0)
            
            let imageHeight : CGFloat  = self.delegate.heightForImageAtIndexPath(
                self.collectionView!, indexPath: indexPath, width: cellWidth)
            
            let bodyHeight : CGFloat  = self.delegate.heightForBodyAtIndexPath(
                self.collectionView!, indexPath: indexPath, width: cellWidth)
            let cellHeight : CGFloat  = imageHeight + bodyHeight;
            
            let cellFrame : CGRect = CGRect(x: cellOriginXList[column],
                                            y: currentCellOriginYList[column],
                                            width: cellWidth,
                                            height: cellHeight);
            
            let attributes : PinterestLayouAttributes = PinterestLayouAttributes(forCellWith: indexPath)
            attributes.imageHeight = imageHeight;
            attributes.frame = cellFrame;
            self.cachedAttributes.append(attributes)
            
            self.contentHeight = max(self.contentHeight, cellFrame.maxY);
            
            currentCellOriginYList[column] = currentCellOriginYList[column] + cellHeight + kCellMargin
            
            var nextColumn : Int = 0
            var minOriginY : CGFloat = CGFloat.greatestFiniteMagnitude
            let nsCurrentCellOriginYList : NSArray = NSArray(array: currentCellOriginYList)
            nsCurrentCellOriginYList.enumerateObjects({ originY, index, stop in
                if ((originY as! CGFloat) < minOriginY) {
                    minOriginY = CGFloat(originY as! NSNumber);
                    nextColumn = index;
                }
            })
            
            column = nextColumn;
        }
    }
}

