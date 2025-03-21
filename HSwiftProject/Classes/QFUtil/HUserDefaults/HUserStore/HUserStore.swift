//
//  HUserStore.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/28.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var KUSER = "H_USER_DEFAULTS"

//class HUserStore: NSObject, NSCoding {
//
//    /** 是否登录 */
//    var isLogin: Bool = false {
//        didSet {
//            if isLogin != oldValue {
//                isLogin ? saveUser() : removeUser()
//            }
//        }
//    }
//
//    /** 用户ID */
//    var userId: String?
//    var userName: String?
//
//    /** 密码 */
//    var password: String?
//
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init()
//        let properties = Mirror(reflecting: self).children
//        for property in properties {
//            if let propertyName = property.label,
//               let propertyValue = aDecoder.decodeObject(forKey: propertyName) {
//                self.setValue(propertyValue, forKey: propertyName)
//            }
//        }
//    }
//
//    func encode(with aCoder: NSCoder) {
//        let properties = Mirror(reflecting: self).children
//        for property in properties {
//            if let propertyName = property.label {
//                let propertyValue = property.value
//                aCoder.encode(propertyValue, forKey: propertyName)
//            }
//        }
//    }
//
//    static var defaults: HUserStore = {
//        if let defaultsUserId = HKeychainSwift.defaults.get(KUSER), !defaultsUserId.isEmpty,
//            let data = HKeychainSwift.defaults.getData(defaultsUserId),
//            let share = try? NSKeyedUnarchiver.unarchivedObject(ofClass: HUserStore.self, from: data),
//            share.responds(to: #selector(loadObserver)) {
//            share.loadObserver()
//            return share
//        } else {
//            let share = HUserStore()
//            share.loadObserver()
//            share.initData()
//            return share
//        }
//    }()
//    
//    override init() {
//        super.init()
//    }
//
//    private static var defaultsUserId: String? {
//        return HUserStore.defaults.userId
//    }
//
//    @objc
//    private func loadObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(saveUser), name: UIApplication.willTerminateNotification, object: nil)
//    }
//    
//    /// 默认初始属性值
//    private func initData() {
//        let dataSource = ["userId": "2222", "userName": "张三", "password": "123456"]
//        dataSource.forEach { (key, value) in
//            self.setValue(value, forKey: key)
//        }
//    }
//
//    @objc
//    private func saveUser() {
//        guard isLogin else { return }
//        if let defaultsUserId = HUserStore.defaultsUserId, !defaultsUserId.isEmpty,
//           let data = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false) {
//            HKeychainSwift.defaults.set(data, forKey: defaultsUserId)
//            HKeychainSwift.defaults.set(defaultsUserId, forKey: KUSER)
//            HKeychainSwift.defaults.synchronizable = true
//        }
//    }
//
//    /// 登出的时候需要移除用户信息
//    private func removeUser() {
//        //删除记录的登录标志
//        HKeychainSwift.defaults.delete(KUSER)
//        HKeychainSwift.defaults.synchronizable = true
//        //清空所有属性值
//        cleanProperties()
//    }
//
//    /// 清空属性值
//    private func cleanProperties() {
//        let properties = Mirror(reflecting: self).children
//        for property in properties {
//            if let propertyName = property.label {
//                let propertyValue = property.value
//                switch propertyValue {
//                case is NSString:
//                    self.setValue("", forKey: propertyName)
//                case is NSNumber:
//                    self.setValue(NSNumber(), forKey: propertyName)
//                case is NSDictionary:
//                    self.setValue([:], forKey: propertyName)
//                case is NSArray:
//                    self.setValue([], forKey: propertyName)
//                default:
//                    self.setValue(nil, forKey: propertyName)
//                }
//            }
//        }
//        //加载默认初始属性值
//        initData()
//    }
//
//    /// 如果属性和字典中的key不一致，可以重写此方法 / 或者readonly
//    /// 不一致的key和对应的value都会通过这个方法返回，可以在此方法中做特殊处理
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        //NSLog(@"-------> forUndefinedKey:%@  value:%@",key,value)
//    }
//
//    ///线上环境链接
//    func setBaseLink(_ baseLink: String) {
//        UserDefaults.standard.set(baseLink, forKey: "baseLink")
//        UserDefaults.standard.synchronize()
//    }
//    func baseLink() -> String? {
//        UserDefaults.standard.object(forKey: "baseLink") as? String
//    }
//
//}

class HUserStore: NSObject, NSCoding {
    // 是否登录
    var isLogin: Bool = false {
        didSet {
            if isLogin != oldValue {
                isLogin ? saveUser() : removeUser()
            }
        }
    }

    // 用户ID
    var userId: String?
    var userName: String?
    // 密码
    var password: String?

    // 单例
    static let defaults: HUserStore = {
        if let defaultsUserId = HKeychainSwift.defaults.get(KUSER),
           let data = HKeychainSwift.defaults.getData(defaultsUserId),
           let store = try? NSKeyedUnarchiver.unarchivedObject(ofClass: HUserStore.self, from: data) {
            return store
        }
        let newStore = HUserStore()
        newStore.initData()
        return newStore
    }()

    // 初始化
    override init() {
        super.init()
        setupNotificationObserver()
    }

    // 初始化属性
    private func initData() {
        userId = "2222"
        userName = "张三"
        password = "123456"
    }

    // 注册通知监听
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveUser), name: UIApplication.willTerminateNotification, object: nil)
    }

    // 保存用户信息
    @objc
    private func saveUser() {
        guard isLogin, let userId = userId else { return }
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false) {
            HKeychainSwift.defaults.set(data, forKey: userId)
            HKeychainSwift.defaults.set(userId, forKey: KUSER)
            HKeychainSwift.defaults.synchronizable = true
        }
    }

    // 移除用户信息
    private func removeUser() {
        HKeychainSwift.defaults.delete(KUSER)
        HKeychainSwift.defaults.synchronizable = true
        cleanProperties()
    }

    // 清空属性值
    private func cleanProperties() {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let propertyName = child.label {
                let defaultValue: Any? = {
                    switch child.value {
                    case is String:
                        return ""
                    case is NSNumber:
                        return NSNumber()
                    case is [AnyHashable: Any]:
                        return [:]
                    case is [Any]:
                        return []
                    default:
                        return nil
                    }
                }()
                setValue(defaultValue, forKey: propertyName)
            }
        }
        initData()
    }

    // 编码方法
    func encode(with aCoder: NSCoder) {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let propertyName = child.label {
                aCoder.encode(child.value, forKey: propertyName)
            }
        }
    }

    // 解码方法
    required init?(coder aDecoder: NSCoder) {
        super.init()
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let propertyName = child.label {
                let decodedValue = aDecoder.decodeObject(forKey: propertyName)
                setValue(decodedValue, forKey: propertyName)
            }
        }
    }

    // 设置线上环境链接
    func setBaseLink(_ baseLink: String) {
        UserDefaults.standard.set(baseLink, forKey: "baseLink")
        // 在 iOS 9 之后，synchronize 会自动调用，不需要手动调用
        // UserDefaults.standard.synchronize()
    }

    // 获取线上环境链接
    func baseLink() -> String? {
        return UserDefaults.standard.string(forKey: "baseLink")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
