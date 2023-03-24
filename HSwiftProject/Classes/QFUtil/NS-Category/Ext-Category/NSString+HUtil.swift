//
//  NSString+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import CommonCrypto

extension String {
    
    var length: Int {
        return self.count
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
    
    func md5() -> String {
        let concat_str = self.cString(using: String.Encoding.utf8)
        var result = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(concat_str, CC_LONG(strlen(concat_str!)), &result)
        var hash = ""
        for i in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            hash += String(format: "%02x", result[i])
        }
        return hash
    }

}
