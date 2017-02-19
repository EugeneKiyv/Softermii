//
//  AuthorizeViewController.swift
//  Softermii
//
//  Created by Eugene Kuropatenko on 2/17/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class AuthorizeViewController: UIViewController {
    @IBOutlet weak var loginButton: UIBarButtonItem!
    var firsAppear = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.gettingRequestToken(sender: self, success: {
            [weak self] in
            self?.cancel(nil)
        }) {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firsAppear  {
            firsAppear = false
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}

extension AuthorizeViewController:UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
