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
        //let propertys = class_copyPropertyList(self.classForCoder, &count)
        let propertys = class_copyIvarList(self.classForCoder, &count)
        if propertys != nil {
            for i in 0..<count {
                let property = propertys![Int(i)]
                let name = ivar_getName(property)
                //isLogin 这个属性的值由外部业务赋值
                if name != nil {
                    //通过KVC的方式赋值
                    let aKey = String(cString: name!)
                    let propertyValue: AnyObject? = self.value(forKey: aKey) as AnyObject
                    
                    if propertyValue == nil || propertyValue!.isKind(of: NSNull.self) {
                        continue
                    }

                    //通过KVC的方式赋值
                    if (self.setupDefaults().containsObject(aKey)) {
                        //加载初始默认值
                        let propertyValue = self.setupDefaults().object(forKey: aKey)
                        self.setValue(propertyValue, forKey: aKey)
                    }else {
                        self.setValue(nil, forKey: aKey)
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
}
