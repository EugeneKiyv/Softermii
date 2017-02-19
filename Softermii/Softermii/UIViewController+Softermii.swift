//
//  UIView+Softermii.swift
//  Softermii
//
//  Created by Eugene Kuropatenko on 2/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showPopupWithTitle(_ title:String?, text:String?, button:String) {
        showPopupWithTitle(title, text: text, button: button, finish: nil)
    }
    
    func showPopupWithTitle(_ title:String?, text:String?, button:String, finish:(()->())?) {
        let avc = UIAlertController(title: title, message:text, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: button, style: .default) { (action) in
            finish?()
        }
        avc.addAction(actionButton)
        DispatchQueue.main.async {
            self.present(avc, animated: true, completion: nil)
        }
    }
}
