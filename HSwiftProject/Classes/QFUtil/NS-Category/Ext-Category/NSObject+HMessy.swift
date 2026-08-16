//
//  NSObject+HMessy.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private final class HWeakBox: NSObject {
    weak var object: AnyObject?
    init(_ object: AnyObject) {
        self.object = object
        super.init()
    }
}

extension NSObject {
    func setAssociateValue(_ value: Any?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    func setAssociateWeakValue(_ value: Any?, key: UnsafeRawPointer) {
        guard let value else {
            objc_setAssociatedObject(self, key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return
        }
        if Swift.type(of: value) is AnyClass {
            objc_setAssociatedObject(self, key, HWeakBox(value as AnyObject), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } else {
            objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func setAssociateCopyValue(_ value: Any?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    func getAssociatedValueForKey(_ key: UnsafeRawPointer) -> Any? {
        let value = objc_getAssociatedObject(self, key)
        if let box = value as? HWeakBox {
            return box.object
        }
        return value
    }
    func removeAssociatedValues() {
        objc_removeAssociatedObjects(self)
    }
    
    static func setAssociateValue(_ value: Any?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    static func setAssociateWeakValue(_ value: Any?, key: UnsafeRawPointer) {
        guard let value else {
            objc_setAssociatedObject(self, key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return
        }
        if Swift.type(of: value) is AnyClass {
            objc_setAssociatedObject(self, key, HWeakBox(value as AnyObject), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } else {
            objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    static func setAssociateCopyValue(_ value: Any?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    static func getAssociatedValueForKey(_ key: UnsafeRawPointer) -> Any? {
        let value = objc_getAssociatedObject(self, key)
        if let box = value as? HWeakBox {
            return box.object
        }
        return value
    }
    static func removeAssociatedValues() {
        objc_removeAssociatedObjects(self)
    }
}

extension NSDictionary {
    
    //将字典转化成json data
    var jsonData: NSData? {
        return try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
    }

    //将字典转化成字符串 如：rn=1&tt=3&rr=4
    var linkString: NSString {
        var parts: [String] = []
        parts.reserveCapacity(count)
        for key in allKeys {
            let value = self[key]
            parts.append("\(key)=\(value.map { "\($0)" } ?? "")")
        }
        return parts.joined(separator: "&") as NSString
    }
    
    //将字典转化成json字符串
    var jsonString: NSString? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) else { return nil }
        return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
    }

    //去掉json字符串中的空格和换行符
    var jsonString2: NSString? {
        var jsonString = self.jsonString
        jsonString = jsonString?.replacingOccurrences(of: " ", with: "") as? NSString
        jsonString = jsonString?.replacingOccurrences(of: "\n", with: "") as? NSString
        return jsonString
    }
    
}

extension Dictionary {
    
    //将字典转化成json data
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) as Data
    }

    //将字典转化成字符串 如：rn=1&tt=3&rr=4
    var linkString: String {
        var parts: [String] = []
        parts.reserveCapacity(count)
        for (key, value) in self {
            parts.append("\(key)=\(value)")
        }
        return parts.joined(separator: "&")
    }
    
    //将字典转化成json字符串
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) else { return nil }
        return String(data: jsonData, encoding: String.Encoding.utf8)
    }

    //去掉json字符串中的空格和换行符
    var jsonString2: String? {
        var jsonString = self.jsonString
        jsonString = jsonString?.replacingOccurrences(of: " ", with: "")
        jsonString = jsonString?.replacingOccurrences(of: "\n", with: "")
        return jsonString
    }
    
}

extension NSString {
    //将json字符串转化成字典
    var dictionary: NSDictionary? {
        guard let data = self.data(using: String.Encoding.utf8.rawValue) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
    }
    //将字符串转化data
    var dataValue: NSData? {
        return self.data(using: String.Encoding.utf8.rawValue) as? NSData
    }
}

extension String {
    //将json字符串转化成字典
    var dictionary: Dictionary<String, Any>? {
        guard let data = self.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary
    }
    //将字符串转化data
    var dataValue: Data? {
        return self.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
    }
}


extension NSData {
    //将json data转化成字典
    var dictionary: NSDictionary? {
        return try? JSONSerialization.jsonObject(with: self as Data, options: .mutableContainers) as? NSDictionary
    }
    //将data转化成字符串
    var stringValue: NSString? {
        return NSString(data: self as Data, encoding: String.Encoding.utf8.rawValue)
    }
}

extension Data {
    //将json data转化成字典
    var dictionary: Dictionary<String, Any>? {
        return try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? Dictionary
    }
    //将data转化成字符串
    var stringValue: String? {
        return String(data: self, encoding: .utf8)
    }
}
