//
//  NSObject+HSafeMessy.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/21.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension NSNull {
    static var arrayValue: [Any]? {
        return nil
    }
    var arrayValue: [Any]? {
        return nil
    }
    static var dictionaryValue: [String: Any]? {
        return nil
    }
    var dictionaryValue: [String: Any]? {
        return nil
    }
    static var stringValue: String? {
        return nil
    }
    var stringValue: String? {
        return nil
    }
    static var length: Int {
        return 0
    }
    var length: Int {
        return 0
    }
    static var isEmpty: Bool {
        return true
    }
    var isEmpty: Bool {
        return true
    }
}

extension NSNumber {
    var arrayValue: [Any]? {
        return nil
    }
    var dictionaryValue: [String: Any]? {
        return nil
    }
    var length: Int {
        return self.stringValue.count
    }
    var stringValue: String {
        let string = String(format: "%lf", self.doubleValue)
        let decimalNumber = NSDecimalNumber(string: string)
        return decimalNumber.description(withLocale: nil)
    }
    var isEmpty: Bool {
        let string = self.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.count == 0 {
            return true
        }
        return false
    }
}

extension String {
    var arrayValue: [Any]? {
        return nil
    }
    var dictionaryValue: [String: Any]? {
        return nil
    }
    var stringValue: String? {
        return self
    }
    var isEmpty: Bool {
        let string = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.count == 0 {
            return true
        }
        return false
    }
}

extension Dictionary {
    var arrayValue: [Any]? {
        return [self]
    }
    var dictionaryValue: [String: Any]? {
        return self as? [String: Any]
    }
    var stringValue: String? {
        return nil
    }
    var length: Int {
        return self.count
    }
    var isEmpty: Bool {
        if self.count == 0 {
            return true
        }
        return false
    }
}

extension Array {
    var arrayValue: [Any]? {
        return self
    }
    var stringValue: String? {
        return nil
    }
    var length: Int {
        return self.count
    }
    var isEmpty: Bool {
        if self.count == 0 {
            return true
        }
        return false
    }
}
