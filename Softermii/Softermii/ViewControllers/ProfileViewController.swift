//
//  ProfileViewController.swift
//  Softermii
//
//  Created by Eugene Kuropatenko on 2/17/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var loginInfo: UIView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if !Preferences.isLogged {
            login(nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Preferences.isLogged {
            showProfile()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func login(_ sender: Any?) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "AuthorizeViewController")
        present(vc, animated: true, completion: nil)
    }
    
    func showProfile() {
        navigationItem.rightBarButtonItem = nil
        loginInfo.isHidden = false
        fullnameLabel.text = Preferences.fullName ?? ""
        usernameLabel.text = Preferences.userName ?? ""
    }
}

