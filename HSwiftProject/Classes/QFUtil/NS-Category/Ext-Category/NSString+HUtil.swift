//
//  NSString+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension String {
    
    var length: Int {
        return self.lengthOfBytes(using: .utf8)
    }
    
    var intValue: Int {
        return Int(self)!
    }

    var floatValue: Float {
        return Float(self)!
    }

    var doubleValue: Double {
        return Double(self)!
    }
    
    func from(loc: Int) -> String {
        if loc >= 0, loc < self.length {
            let startIndex = self.index(self.startIndex, offsetBy: loc)
            let endIndex = self.endIndex
            return String(self[startIndex..<endIndex])
        }
        return ""
    }

    func to(loc: Int) -> String {
        if loc >= 0, loc < self.length {
            return String(self.prefix(loc))
        }
        return ""
    }

    func rangeOf(_ subString: String) -> NSRange {
        if self.contains(subString) {
            return NSString(string: self).range(of: subString, options: String.CompareOptions.caseInsensitive)
        }
        return NSRange(location: 0, length: 0)
    }
    
    static func leftArrowString() -> String {
        return "‹"
    }
    static func rightArrowString() -> String {
        return "›"
    }
    static func cancelString() -> String {
        return "✕"
    }
    static func checkedString() -> String {
        return "√"
    }

    func encode() -> String {
        let string = self.removingPercentEncoding //先移除已有的相同编码，然后再进行编码
        return string!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    func decode() -> String {
        return self.removingPercentEncoding!
    }

    ///去除字符串两端的空白字符
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }

    static func fromClass(_ cls: AnyClass) -> String {
        return NSStringFromClass(cls)
    }
    func toClass() -> AnyClass {
        return NSClassFromString(self)!
    }
    
    static func fromRect(_ rect: CGRect) -> String {
        return NSCoder.string(for: rect)
    }
    func toRect() -> CGRect {
        return NSCoder.cgRect(for: self)
    }
    
    static func fromSize(_ size: CGSize) -> String {
        return NSCoder.string(for: size)
    }
    func toSize() -> CGSize {
        return NSCoder.cgSize(for: self)
    }
    
    static func fromPoint(_ point: CGPoint) -> String {
        return NSCoder.string(for: point)
    }
    func toPoint() -> CGPoint {
        return NSCoder.cgPoint(for: self)
    }
    
    static func fromRange(_ range: NSRange) -> String {
        return NSStringFromRange(range)
    }
    func toRange() -> NSRange {
        return NSRangeFromString(self)
    }
    
    static func fromSelector(_ aSelector: Selector) -> String {
        return NSStringFromSelector(aSelector)
    }
    func toSelector() -> Selector {
        return NSSelectorFromString(self)
    }
    
    static func fromProtocol(_ proto: Protocol) -> String {
        return NSStringFromProtocol(proto)
    }
    func toProtocol() -> Protocol {
        return NSProtocolFromString(self)!
    }

}
