//
//  PinterestLayouAttributes.swift
//  Softermii
//
//  Created by Eugene Kuropatenko on 2/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

open class PinterestLayouAttributes: UICollectionViewLayoutAttributes {
    open var imageHeight : CGFloat = 0.0
    
    open override func copy(with zone: NSZone?) -> Any {
        let copy : PinterestLayouAttributes = super.copy(with: zone) as! PinterestLayouAttributes
        copy.imageHeight = self.imageHeight;
        
        return copy;
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        if object is PinterestLayouAttributes {
            let attributtes : PinterestLayouAttributes = object as! PinterestLayouAttributes
            
            if (attributtes.imageHeight == self.imageHeight) {
                return super.isEqual(attributtes)
            }
        }
        return false;
    }
}
