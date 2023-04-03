//
//  NSString+HChain.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/23.
//  Copyright © 2023 wind. All rights reserved.
//

import Foundation

extension String {
    func range(_ loc: Int, _ len: Int) -> String {
        if loc >= 0 && len >= 1 && loc + len <= self.count {
            let range = self.index(self.startIndex, offsetBy: loc)..<self.index(self.startIndex, offsetBy: loc + len)
            return String(self[range])
        }
        return ""
    }
    static func format(_ format: String, _ arguments: CVarArg...) -> String {
        return String(format: format, arguments: arguments)
    }
    static func fromClass(_ cls: AnyClass) -> String {
        return String(describing: cls)
    }
    func toClass() -> AnyClass? {
        return NSClassFromString(self)
    }
    static func fromRect(_ rect: CGRect) -> String {
        return String(describing: rect)
    }
    func toRect() -> CGRect {
        return NSCoder.cgRect(for: self)
    }
    static func fromSize(_ size: CGSize) -> String {
        return String(describing: size)
    }
    func toSize() -> CGSize {
        return NSCoder.cgSize(for: self)
    }
    static func fromPoint(_ point: CGPoint) -> String {
        return String(describing: point)
    }
    func toPoint() -> CGPoint {
        return NSCoder.cgPoint(for: self)
    }
    static func fromRange(_ range: NSRange) -> String {
        return String(describing: range)
    }
    func toRange() -> NSRange {
        return NSRangeFromString(self)
    }
    static func fromSelector(_ aSelector: Selector) -> String {
        return String(describing: aSelector)
    }
    func toSelector() -> Selector? {
        return NSSelectorFromString(self)
    }
    static func fromProtocol(_ proto: Protocol) -> String {
        return String(describing: proto)
    }
    func toProtocol() -> Protocol? {
        return NSProtocolFromString(self)
    }
    static func fromCString(_ c: UnsafePointer<Int8>) -> String {
        return String(cString: c, encoding: .utf8) ?? ""
    }
    func toCString() -> UnsafePointer<Int8>? {
        return (self as NSString).utf8String
    }
    func fromIndex(_ loc: Int) -> String {
        if loc >= 0 && loc < self.count {
            let range = self.index(self.startIndex, offsetBy: loc)..<self.endIndex
            return String(self[range])
        }
        return ""
    }
    func toIndex(_ index: Int) -> String {
        if index >= 0 {
            let range: Range<String.Index>
            if index >= self.count {
                range = self.startIndex..<self.endIndex
            } else {
                range = self.startIndex..<self.index(self.startIndex, offsetBy: index + 1)
            }
            return String(self[range])
        }
        return ""
    }
    func fromSubString(_ org: String) -> String {
        if let range = self.range(of: org) {
            return String(self[range.upperBound...])
        }
        return ""
    }
    func toSubString(_ org: String) -> String {
        if let range = self.range(of: org) {
            return String(self[..<range.lowerBound])
        }
        return ""
    }
    static func append(_ obj: Any) -> String {
        return String(describing: obj)
    }
    func append(_ obj: Any) -> String {
        return self + String(describing: obj)
    }
    func appendFormat(_ format: String, _ arguments: CVarArg...) -> String {
        return String(format: format, arguments: arguments)
    }
    static func appendCount(_ org: String, _ count: Int) -> String {
        var mutableStr = ""
        for _ in 0..<count {
            mutableStr += org
        }
        return mutableStr
    }
    func appendCount(_ org: String, _ count: Int) -> String {
        var mutableStr = self
        for _ in 0..<count {
            mutableStr += org
        }
        return mutableStr
    }
    func replace(_ org1: String, _ org2: String) -> String {
        return self.replacingOccurrences(of: org1, with: org2)
    }
    func clearStrings(_ org: [String]) -> String {
        var tmpString = self
        for str in org {
            tmpString = tmpString.replace(str, "")
        }
        return tmpString
    }
    func equal(_ org: String) -> Bool {
        return self == org
    }
    func isClass(_ aClass: AnyClass) -> Bool {
        return self.isKind(of: aClass)
    }
    func componentsByString(_ separator: String) -> [String] {
        return self.components(separatedBy: separator)
    }
    func componentsBySetString(_ separator: String) -> [String] {
        let characterSet = CharacterSet(charactersIn: separator)
        let charSet = CharacterSet.whitespacesAndNewlines
        let arr = self.components(separatedBy: characterSet)
        var mutablerArr = [String]()
        //过滤掉为空的字符串
        for str in arr where str.count > 0 {
            //过滤掉字符串两端为空的字符
            let trimStr = str.trimmingCharacters(in: charSet)
            if trimStr.count > 0 {
                mutablerArr.append(trimStr)
            }
        }
        return mutablerArr
    }

    func componentsByStringBySetString(_ separator: String, _ setSeparator: String) -> [String] {
        var mutablerArr = [String]()
        let arr = self.componentsByString(separator)
        for str in arr {
            let tmpArr = str.componentsBySetString(setSeparator)
            mutablerArr.append(contentsOf: tmpArr)
        }
        return mutablerArr
    }
    func containsStrings(_ org: [String]) -> Bool {
        if org.count <= 0 { return false }
        var contain = true
        for str in org {
            if !self.contains(str) {
                contain = false
            }
        }
        return contain
    }
    subscript(index: Int) -> String? {
        if index >= 0 && index < self.count {
            let range = self.index(self.startIndex, offsetBy: index)..<self.index(self.startIndex, offsetBy: index + 1)
            return String(self[range])
        }
        return nil
    }
    subscript(key: String) -> String {
        if let range = self.range(of: key) {
            return String(describing: range)
        }
        return ""
    }
}
