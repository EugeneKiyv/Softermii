//
//  FlickrPhotoCell.swift
//  Softermii
//
//  Created by Eugene Kuropatenko on 2/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit
import AVFoundation

class FlickrPhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentLabel: UILabel!
    
    func setModel(_ photo:UIImage!, text:String) {
        self.imageView.image = photo
        self.commentLabel.text = text
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if layoutAttributes is PinterestLayouAttributes {
            let attributes : PinterestLayouAttributes = layoutAttributes as! PinterestLayouAttributes
            self.imageViewHeightLayoutConstraint.constant = attributes.imageHeight;
        }
    }
    
    class func imageHeightWithImage(_ image : UIImage, cellWidth : CGFloat) -> CGFloat {
        let boundingRect : CGRect  =  CGRect(x: 0, y: 0, width: cellWidth, height: CGFloat.greatestFiniteMagnitude);
        let rect : CGRect = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect);
        
        return rect.size.height;
    }
    
    class func bodyHeightWithText(_ text : String,  cellWidth : CGFloat) -> CGFloat {
        let padding : CGFloat = 4.0
        let width : CGFloat = (cellWidth - padding * 2)
        let font = UIFont.systemFont(ofSize: 14.0)
        let attributes = [NSFontAttributeName:font]

        let rect : CGRect = text.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                            options : NSStringDrawingOptions.usesLineFragmentOrigin,
                                                            attributes: attributes,
                                                            context: nil)
        return padding + ceil(rect.size.height) + padding
    }
}
