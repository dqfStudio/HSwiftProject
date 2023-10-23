//
//  HUserDefaults.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

// User Defaults Key
private var kUserKey = "ud_user_id"
private var kDefaultsKey = "ud_defaults_id"

class HUserDefaults: NSObject {
    
    // User Defaults
    private static var _user: HUserCore?
    static var user: HUserCore {
        if _user == nil {
            _user = HUserCore(suiteName: HUserDefaults.userCoreKey)
        }
        return _user!
    }
    // Standard Defaults
    static let defaults: HDefaultsCore = {
        return HDefaultsCore()
    }()
    

    // Get User Core Key
    private static var userCoreKey: String {
        return HUserDefaults.defaults.string(forKey: kDefaultsKey) ?? kUserKey
    }
    // Set User Core Key
    static func setUserCoreKey(_ key: String) {
        // Clear User Core Key
        HUserDefaults.clearUserCoreKey()
        // Save User Core Key
        HUserDefaults.defaults.isUserLogin = true
        HUserDefaults.defaults.set(key, forKey: kDefaultsKey)
        HUserDefaults.defaults.synchronize()
    }
    // Clear User Core Key
    static func clearUserCoreKey() {
        HUserDefaults.defaults.isUserLogin = false
        HUserDefaults.defaults.removeObject(forKey: kDefaultsKey)
        HUserDefaults.defaults.synchronize()
        //清除之前用户数据
        HUserDefaults._user = nil
    }

}
