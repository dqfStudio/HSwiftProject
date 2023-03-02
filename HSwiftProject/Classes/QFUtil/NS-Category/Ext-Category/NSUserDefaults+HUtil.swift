//
//  NSUserDefaults+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var KUserDefaultsKey     = "ud_user_defaults_id"
private var KFirstLaunchKey      = "ud_first_launch"
private var KUserFirstLaunchKey  = "ud_user_first_launch"
private var KUserLoginKey        = "ud_user_login"

extension UserDefaults {

    static var userDefaultsId: String {
        get {
            return UserDefaults.standard.object(forKey: KUserDefaultsKey) as! String
        }
        set {
            UserDefaults.saveStandardDefaults { theStandardDefaults in
                theStandardDefaults.set(newValue, forKey: KUserDefaultsKey)
            }
        }
    }
    
    static var theUserDefaults: UserDefaults? {
        let userKey: String? = UserDefaults.standard.object(forKey: KUserDefaultsKey) as? String
        if userKey != nil {
            return UserDefaults(suiteName: userKey)
        }
        return nil
    }

    static var theStandardDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    static func saveUserDefaults(block : (_ theUserDefaults: UserDefaults) -> Void) {
        if UserDefaults.theUserDefaults != nil {
            block(UserDefaults.theUserDefaults!)
            UserDefaults.theUserDefaults?.synchronize()
        }
    }

    static func saveStandardDefaults(block : (_ theStandardDefaults: UserDefaults) -> Void) {
        block(UserDefaults.standard)
        UserDefaults.standard.synchronize()
    }

    static func setAPPFirstLaunch() {
        UserDefaults.saveStandardDefaults { theStandardDefaults in
            theStandardDefaults.set(true, forKey: KFirstLaunchKey)
        }
    }

    static func isAPPFirstLaunch() -> Bool {
        return UserDefaults.standard.bool(forKey: KFirstLaunchKey)
    }

    static func setUserFirstLaunch() {
        UserDefaults.saveUserDefaults { theUserDefaults in
            theUserDefaults.set(true, forKey: KUserFirstLaunchKey)
        }
    }

    static func isUserFirstLaunch() -> Bool {
        return UserDefaults.theUserDefaults?.bool(forKey: KUserFirstLaunchKey) ?? false
    }

    static func setUserLogin() {
        UserDefaults.saveUserDefaults { theUserDefaults in
            theUserDefaults.set(true, forKey: KUserLoginKey)
        }
    }

    static func setUserLogout() {
        UserDefaults.saveUserDefaults { theUserDefaults in
            theUserDefaults.set(false, forKey: KUserLoginKey)
        }
    }

    static func isUserLogin() -> Bool {
        return UserDefaults.theUserDefaults?.bool(forKey: KUserLoginKey) ?? false
    }
    
}
