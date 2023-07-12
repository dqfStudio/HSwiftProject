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
        //加载默认初始属性值
        initData()
    }

    static var defaults: HLRDManager = {
        return HLRDManager()
    }()

    /// 清空属性值
    func clear() {
        cleanProperties()
    }
    
    private func initData() {
        let dataSource = ["userId": "2222", "userName": "张三", "password": "123456"]
        dataSource.forEach { (key, value) in
            self.setValue(value, forKey: key)
        }
    }
    
    /// 清空属性值
    private func cleanProperties() {
        let properties = Mirror(reflecting: self).children
        for property in properties {
            if let propertyName = property.label {
                let propertyValue = property.value
                switch propertyValue {
                case is NSString:
                    self.setValue("", forKey: propertyName)
                case is NSNumber:
                    self.setValue(NSNumber(), forKey: propertyName)
                case is NSDictionary:
                    self.setValue(NSDictionary(), forKey: propertyName)
                case is NSArray:
                    self.setValue(NSArray(), forKey: propertyName)
                default:
                    self.setValue(nil, forKey: propertyName)
                }
            }
        }
        //加载默认初始属性值
        initData()
    }

    /// 如果属性和字典中的key不一致，可以重写此方法 / 或者readonly
    /// 不一致的key和对应的value都会通过这个方法返回，可以在此方法中做特殊处理
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //NSLog(@"-------> forUndefinedKey:%@  value:%@",key,value)
    }
}
