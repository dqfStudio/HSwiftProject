//
//  UserDefaults+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

// User Defaults Key
private var KUserDefaultsKey     = "ud_user_defaults_id"
// First Launch Key
private var KFirstLaunchKey      = "ud_first_launch"
// User First Launch Key
private var KUserFirstLaunchKey  = "ud_user_first_launch"
// User Login Key
private var KUserLoginKey        = "ud_user_login"

extension UserDefaults {

    // User Defaults Key
    static var userKey: String {
        get {
            return UserDefaults.defaults.object(forKey: KUserDefaultsKey) as! String
        }
        set {
            UserDefaults.saveDefaults { defaults in
                defaults.set(newValue, forKey: KUserDefaultsKey)
            }
        }
    }
    
    
    // User Defaults
    static var user: UserDefaults {
        let userKey: String = UserDefaults.defaults.object(forKey: KUserDefaultsKey) as! String
        return UserDefaults(suiteName: userKey)!
    }
    // Standard Defaults
    static var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    
    // Save User Defaults
    static func saveUser(block : (_ user: UserDefaults) -> Void) {
        block(UserDefaults.user)
        UserDefaults.user.synchronize()
    }
    // Save Standard Defaults
    static func saveDefaults(block : (_ defaults: UserDefaults) -> Void) {
        block(UserDefaults.defaults)
        UserDefaults.defaults.synchronize()
    }

    
    // Check if APP is First Launch
    static func isAPPFirstLaunch() -> Bool {
        return UserDefaults.defaults.bool(forKey: KFirstLaunchKey)
    }
    // Set APP First Launch
    static func setAPPFirstLaunch() {
        UserDefaults.saveDefaults { defaults in
            defaults.set(true, forKey: KFirstLaunchKey)
        }
    }

    
    // Check if User is First Launch
    static func isUserFirstLaunch() -> Bool {
        return UserDefaults.user.bool(forKey: KUserFirstLaunchKey)
    }
    // Set User First Launch
    static func setUserFirstLaunch() {
        UserDefaults.saveUser { user in
            user.set(true, forKey: KUserFirstLaunchKey)
        }
    }


    // Check if User is Logged In
    static func isUserLogin() -> Bool {
        return UserDefaults.user.bool(forKey: KUserLoginKey)
    }
    // Set User Logged In
    static func setUserLogin() {
        UserDefaults.saveUser { user in
            user.set(true, forKey: KUserLoginKey)
        }
    }
    // Set User Logged Out
    static func setUserLogout() {
        UserDefaults.saveUser { user in
            user.set(false, forKey: KUserLoginKey)
        }
    }
    
}
