//
//  HLRDManager.swift
//  HSwiftProject
//
//  Created by Wind on 17/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import Foundation

/// HUserLiveDataManager
/// 管理LiveRoom中的全局数据
class HLRDManager : NSObject {

    private override init() {
        super.init()
        //加载初始默认值
        self._setupDefaults()
    }

    static var defaults: HLRDManager = {
        return HLRDManager()
    }()

    private func setupDefaults() -> NSDictionary {
        return ["isLogin": 0, "userId": "111"]
    }

    //清空属性值
    func clear() {
        self.cleanAllProperties()
    }
    
    private func _setupDefaults() {
        let setupDefaultSEL = NSSelectorFromString("setupDefaults")
        if (self.responds(to: setupDefaultSEL)) {
            let defaultsDict = self.perform(setupDefaultSEL).takeUnretainedValue() as! NSDictionary
            for (aKey, aValue) in defaultsDict {
                self.setValue(aValue, forKey: aKey as! String)
            }
        }
    }
    
    /**
    清空属性值
    */
    private func cleanAllProperties() {
        var count: UInt32 = 0
        let propertys = class_copyIvarList(self.classForCoder, &count)
        if let propertys = propertys {
            for i in 0..<count {
                let property = propertys[Int(i)]
                let name = ivar_getName(property)
                if let name = name {
                    let aKey = String(cString: name)
                    let propertyValue = self.value(forKey: aKey)
                    if propertyValue == nil || propertyValue is NSNull {
                        continue
                    }
                    if self.setupDefaults().containsObject(aKey) {
                        let propertyValue = self.setupDefaults().object(forKey: aKey)
                        self.setValue(propertyValue, forKey: aKey)
                    } else {
                        self.setValue(nil, forKey: aKey)
                    }
                }
            }
            free(propertys)
        }
    }


    /// 如果属性和字典中的key不一致，可以重写此方法 / 或者readonly
    /// 不一致的key和对应的value都会通过这个方法返回，可以在此方法中做特殊处理
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //NSLog(@"-------> forUndefinedKey:%@  value:%@",key,value)
    }
}
