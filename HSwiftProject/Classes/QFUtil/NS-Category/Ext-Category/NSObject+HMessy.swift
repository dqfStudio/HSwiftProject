//
//  NSObject+HMessy.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension NSObject {
    func setAssociateValue(_ value: Any?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    func setAssociateWeakValue(_ value: Any?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_ASSIGN)
    }
    func setAssociateCopyValue(_ value: Any?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    func getAssociatedValueForKey(_ key: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, key)
    }
    func removeAssociatedValues() {
        objc_removeAssociatedObjects(self)
    }
    
    static func setAssociateValue(_ value: Any?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    static func setAssociateWeakValue(_ value: Any?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_ASSIGN)
    }
    static func setAssociateCopyValue(_ value: Any?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    static func getAssociatedValueForKey(_ key: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, key)
    }
    static func removeAssociatedValues() {
        objc_removeAssociatedObjects(self)
    }
}

extension NSDictionary {
    
    //将字典转化成json data
    var jsonData: NSData {
        return try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
    }

    //将字典转化成字符串 如：rn=1&tt=3&rr=4
    var linkString: NSString {
        let mutableString = NSMutableString()
        for key in self.allKeys {
            let value = self[key]
            mutableString.append(key as! String)
            mutableString.append("=")
            mutableString.append(value as! String)
            mutableString.append("&")
        }
        return mutableString.substring(to: mutableString.length - 1) as NSString
    }
    
    //将字典转化成json字符串
    var jsonString: NSString {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
    }

    //去掉json字符串中的空格和换行符
    var jsonString2: NSString {
        var jsonString = self.jsonString
        jsonString = jsonString.replacingOccurrences(of: " ", with: "") as NSString
        jsonString = jsonString.replacingOccurrences(of: "\n", with: "") as NSString
        return jsonString
    }
    
}

extension Dictionary {
    
    //将字典转化成json data
    var jsonData: Data {
        return try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) as Data
    }

    //将字典转化成字符串 如：rn=1&tt=3&rr=4
    var linkString: String {
        let mutableString = NSMutableString()
        for key in self.keys {
            let value = self[key]
            mutableString.append(key as! String)
            mutableString.append("=")
            mutableString.append(value as! String)
            mutableString.append("&")
        }
        return mutableString.substring(to: mutableString.length - 1)
    }
    
    //将字典转化成json字符串
    var jsonString: String {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        return String(data: jsonData, encoding: String.Encoding.utf8)!
    }

    //去掉json字符串中的空格和换行符
    var jsonString2: String {
        var jsonString = self.jsonString
        jsonString = jsonString.replacingOccurrences(of: " ", with: "")
        jsonString = jsonString.replacingOccurrences(of: "\n", with: "")
        return jsonString
    }
    
}

extension NSString {
    //将json字符串转化成字典
    var dictionary: NSDictionary {
        return try! JSONSerialization.jsonObject(with: self.data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as! NSDictionary
    }
    //将字符串转化data
    var dataValue: NSData {
        return self.data(using: String.Encoding.utf8.rawValue)! as NSData
    }
}

extension String {
    //将json字符串转化成字典
    var dictionary: Dictionary<String, Any> {
        return try! JSONSerialization.jsonObject(with: self.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, options: .mutableContainers) as! Dictionary
    }
    //将字符串转化data
    var dataValue: Data {
        return self.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as Data
    }
}


extension NSData {
    //将json data转化成字典
    var dictionary: NSDictionary {
        return try! JSONSerialization.jsonObject(with: self as Data, options: .mutableContainers) as! NSDictionary
    }
    //将data转化成字符串
    var stringValue: NSString {
        return NSString(data: self as Data, encoding: String.Encoding.utf8.rawValue)!
    }
}

extension Data {
    //将json data转化成字典
    var dictionary: Dictionary<String, Any> {
        return try! JSONSerialization.jsonObject(with: self, options: .mutableContainers) as! Dictionary
    }
    //将data转化成字符串
    var stringValue: String {
        return String(data: self, encoding: .utf8)!
    }
}
