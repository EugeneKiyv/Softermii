//
//  Preferences.swift
//  Softermii
//
//  Created by Eugene Kuropatenko on 2/17/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

fileprivate let kOauthTokenSecretKey = "kOauthTokenSecretKey"
fileprivate let kFullnameKey = "kFullnameKey"
fileprivate let kOauthTokenKey = "kOauthTokenKey"
fileprivate let kUserNameKey = "kUserNameKey"
fileprivate let kUserSidKey = "kUserSidKey"

class Preferences {
    static var isLogged:Bool{
        get {
            if let _ = UserDefaults.standard.value(forKey: kUserNameKey) as? String {
                return true
            }
            return false
        }
    }
    
    static var userName:String? {
        get {
            return UserDefaults.standard.value(forKey: kUserNameKey) as? String
        }
    }

    static var fullName:String? {
        get {
            return UserDefaults.standard.value(forKey: kFullnameKey) as? String
        }
    }
    
    static var userId:String? {
        get {
            return UserDefaults.standard.value(forKey: kUserSidKey) as? String
        }
    }
    
    static func saveUser(_ user:[String:Any]) {
        UserDefaults.standard.set(user["oauth_token_secret"], forKey: kOauthTokenSecretKey)
        UserDefaults.standard.set(user["oauth_token"], forKey: kOauthTokenKey)
        UserDefaults.standard.set(user["fullname"], forKey: kFullnameKey)
        UserDefaults.standard.set(user["username"], forKey: kUserNameKey)
        UserDefaults.standard.set(user["user_nsid"], forKey: kUserSidKey)
        UserDefaults.standard.synchronize()
    }
}
