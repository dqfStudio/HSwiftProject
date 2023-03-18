//
//  HUserStore.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/28.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var KUSER = "H_USER_DEFAULTS"

class HUserStore : NSObject {


    /** 是否登录 */
    private var _isLogin: Bool = false
    var isLogin: Bool {
        get {
            return _isLogin
        }
        set {
            if _isLogin != newValue {
                _isLogin = newValue
                if _isLogin {
                    self.saveUser()
                }else {
                    self.removeUser()
                }
            }
        }
    }


    /** 用户ID */
    var userId: String?
    var userName: String = ""
    var realname: String?

    /** 密码 */
    var password: String?

    private init?(coder aDecoder: NSCoder) {
        super.init()
        var count: UInt32 = 0
        //let propertys = class_copyPropertyList(self.classForCoder, &count)
        let propertys = class_copyIvarList(self.classForCoder, &count)
        if propertys != nil {
            for i in 0..<count {
                let property = propertys![Int(i)]
                let name = ivar_getName(property)
                if name != nil {
                    let key = String(cString: name!)
                    let value = aDecoder.decodeObject(forKey: key)
                    self.setValue(value, forKey: key)
                }
            }
            free(propertys)
        }
    }

    private func encodeWithCoder(aCoder: NSCoder) {
        var count: UInt32 = 0
        //let propertys = class_copyPropertyList(self.classForCoder, &count)
        let propertys = class_copyIvarList(self.classForCoder, &count)
        if propertys != nil {
            for i in 0..<count {
                let property = propertys![Int(i)]
                let name = ivar_getName(property)
                if name != nil {
                    let key = String(cString: name!)
                    aCoder.encode(self.value(forKey: key), forKey: key)
                }
            }
            free(propertys)
        }
    }

    
    private override init() {
        super.init()
    }

    static var defaults: HUserStore = {
        var share: HUserStore?
        let defaultsUserId: String? = HKeyChainStore.keyChainStore.stringForKey(KUSER)
        if defaultsUserId != nil {
            let data: Data? = HKeyChainStore.keyChainStore.dataForKey(defaultsUserId)
            if data != nil {
                if #available(iOS 11.0, *) {
                    share = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [HUserStore.self], from: data!) as! HUserStore
                }else {
                    share = NSKeyedUnarchiver.unarchiveObject(with: data!) as? HUserStore
                }
            }
        }
        if share == nil || share!.responds(to: #selector(initData)) == false {
            share = HUserStore()
        }
        share!.initData()
        return share!
    }()

    private static var defaultsUserId: String? {
        return HUserStore.defaults.userName.uppercased()
    }

    //初始化数据
    @objc
    private func initData() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveUser), name: UIApplication.willTerminateNotification, object: nil)
    }

    @objc
    private func saveUser() {
        if self.isLogin {
            var data: Data?
            if #available(iOS 11.0, *) {
                data = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
            }else {
                data = NSKeyedArchiver.archivedData(withRootObject: self)
            }
            let defaultsUserId = HUserStore.defaultsUserId
            if defaultsUserId!.length > 0 && data != nil {
                HKeyChainStore.keyChainStore.setData(data: data, forKey: defaultsUserId)
                HKeyChainStore.keyChainStore.setString(string: defaultsUserId, forKey: KUSER)
                HKeyChainStore.keyChainStore.synchronizable = true
            }
        }
    }

    ///加载钥匙串中的数据
    func loadKeyChainDataWith(_ userName: String, pwd: String) -> Bool {

        var boolValue: Bool = false
        if userName.length > 3 {
            let defaultsUserId: String = userName.uppercased()
            let data: Data? = HKeyChainStore.keyChainStore.dataForKey(defaultsUserId)
            if data != nil {
                var userDefaults: HUserStore?
                if #available(iOS 11.0, *) {
                    userDefaults = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [HUserStore.self], from: data!) as? HUserStore
                } else {
                    userDefaults = NSKeyedUnarchiver.unarchiveObject(with: data!) as? HUserStore
                }
                let propertyValue = userDefaults!.value(forKey: "password") as! String
                //密码不相等则不能提取用户信息
                if pwd != propertyValue {
                    userDefaults = nil
                    return boolValue
                }

                boolValue = true
                
                var count: UInt32 = 0
                //let propertys = class_copyPropertyList(self.classForCoder, &count)
                let propertys = class_copyIvarList(self.classForCoder, &count)
                if propertys != nil {
                    for i in 0..<count {
                        let property = propertys![Int(i)]
                        let name = ivar_getName(property)
                        //isLogin 这个属性的值由外部业务赋值
                        if name != nil {
                            //通过KVC的方式赋值
                            let key = String(cString: name!)
                            if key != "isLogin" {
                                let propertyValue: Any? = userDefaults!.value(forKey: key)
                                self.setValue(propertyValue, forKey: key)
                            }
                        }
                    }
                    // 释放
                    userDefaults = nil
                    free(propertys)
                }
            }
        }
        return boolValue
    }

    //登出的时候需要移除用户信息
    private func removeUser() {
        //删除记录的登录标志
        HKeyChainStore.keyChainStore.setString(string: nil, forKey: KUSER)
        HKeyChainStore.keyChainStore.synchronizable = true
        //清空所有属性值
        self.cleanAllProperties()
    }

    /**
    清空属性值
    */
    private func cleanAllProperties() {
        
        var count: UInt32 = 0
        //let propertys = class_copyPropertyList(self.classForCoder, &count)
        let propertys = class_copyIvarList(self.classForCoder, &count)
        if propertys != nil {
            for i in 0..<count {
                let property = propertys![Int(i)]
                let name = ivar_getName(property)
                //isLogin 这个属性的值由外部业务赋值
                if name != nil {
                    //通过KVC的方式赋值
                    let key = String(cString: name!)
                    let propertyValue: AnyObject? = self.value(forKey: key) as AnyObject
                    
                    if propertyValue == nil || propertyValue!.isKind(of: NSNull.self) {
                        continue
                    }
                    
                    //通过KVC的方式赋值
                    
                    if propertyValue!.isKind(of: NSString.self) {
                        self.setValue("", forKey: key)
                    }
                    else if propertyValue!.isKind(of: NSNumber.self) {
                        self.setValue(NSNumber(), forKey: key)
                    }
                    else if propertyValue!.isKind(of: NSMutableDictionary.self) ||
                             propertyValue!.isKind(of: NSDictionary.self) {
                        self.setValue(NSDictionary(), forKey: key)
                    }
                    else if propertyValue!.isKind(of: NSMutableArray.self) ||
                             propertyValue!.isKind(of: NSArray.self) {
                        self.setValue(NSArray(), forKey: key)
                    }
                    else {
                        self.setValue(nil, forKey: key)
                    }
                }
            }
            // 释放
            free(propertys)
        }
    }

    /// 如果属性和字典中的key不一致，可以重写此方法 / 或者readonly
    /// 不一致的key和对应的value都会通过这个方法返回，可以在此方法中做特殊处理
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //NSLog(@"-------> forUndefinedKey:%@  value:%@",key,value)
    }

    ///线上环境链接
    func setBaseLink(_ baseLink: NSString) {
        UserDefaults.standard.set(baseLink, forKey: "baseLink")
        UserDefaults.standard.synchronize()
    }
    func baseLink() -> NSString {
        UserDefaults.standard.object(forKey: "baseLink") as! NSString
    }
    

    func setH5Link(_ h5Link: NSString) {
        UserDefaults.standard.set(h5Link, forKey: "h5Link")
        UserDefaults.standard.synchronize()
    }
    func h5Link() -> NSString {
        UserDefaults.standard.object(forKey: "h5Link") as! NSString
    }


    func setPlatCodeLink(_ platCodeLink: NSString) {
        UserDefaults.standard.set(platCodeLink, forKey: "platCodeLink")
        UserDefaults.standard.synchronize()
    }
    func platCodeLink() -> NSString {
        UserDefaults.standard.object(forKey: "platCodeLink") as! NSString
    }


    func setSrc1Link(_ src1Link: NSString) {
        UserDefaults.standard.set(src1Link, forKey: "src1Link")
        UserDefaults.standard.synchronize()
    }
    func src1Link() -> NSString {
        UserDefaults.standard.object(forKey: "src1Link") as! NSString
    }

}

