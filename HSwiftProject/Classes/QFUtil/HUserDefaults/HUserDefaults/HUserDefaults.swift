//
//  HUserDefaults.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

// User Defaults Key
private var KUserDefaultsKey = "ud_user_defaults_id"

class HUserDefaults: NSObject {
    
    // User Defaults
    private static var _user: HUserCore?
    static var user: HUserCore {
        get {
            if _user == nil {
                _user = HUserCore(suiteName: HUserDefaults.userCoreKey)!
            }
            return _user!
        }
        set {
            if _user != newValue {
                _user = newValue
            }
        }
    }
    // Standard Defaults
    static var defaults: HDefaultsCore {
        return HDefaultsCore()
    }
    
    
    // Get User Core Key
    private static var userCoreKey: String {
        return HUserDefaults.defaults.string(forKey: KUserDefaultsKey)!
    }
    // Set User Core Key
    static func setUserCoreKey(_ key: String) {
        // 再保存新的数据
        HUserDefaults.defaults.isUserLogin = true
        HUserDefaults.defaults.set(key, forKey: KUserDefaultsKey)
        HUserDefaults.defaults.synchronize()
    }
    // Clear User Core Key
    static func clearUserCoreKey() {
        HUserDefaults.defaults.isUserLogin = false
        HUserDefaults.defaults.removeObject(forKey: KUserDefaultsKey)
        HUserDefaults.defaults.synchronize()
        //清除之前用户信息
        HUserDefaults._user = nil
    }

}
