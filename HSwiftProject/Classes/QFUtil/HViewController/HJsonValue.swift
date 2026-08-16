//
//  HJsonValue.swift
//  HSwiftProject
//
//  Created by windy on 2025/11/14.
//  Copyright © 2025 wind. All rights reserved.
//

import Foundation

enum JSONValue: Codable, Equatable, CustomStringConvertible, CustomDebugStringConvertible {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case dictionary([String: JSONValue])
    case array([JSONValue])
    case null
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        jsonString ?? "null"
    }
    
    var debugDescription: String {
        "JSONValue(\(description))"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self = .null
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let dictionaryValue = try? container.decode([String: JSONValue].self) {
            self = .dictionary(dictionaryValue)
        } else if let arrayValue = try? container.decode([JSONValue].self) {
            self = .array(arrayValue)
        } else {
            throw DecodingError.typeMismatch(
                JSONValue.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to decode JSONValue")
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let stringValue):
            try container.encode(stringValue)
        case .int(let intValue):
            try container.encode(intValue)
        case .double(let doubleValue):
            try container.encode(doubleValue)
        case .bool(let boolValue):
            try container.encode(boolValue)
        case .dictionary(let dictionaryValue):
            try container.encode(dictionaryValue)
        case .array(let arrayValue):
            try container.encode(arrayValue)
        case .null:
            try container.encodeNil()
        }
    }
}

// MARK: - 便利属性

extension JSONValue {
    
    var isArray: Bool { if case .array = self { return true }; return false }
    var isDictionary: Bool { if case .dictionary = self { return true }; return false }
    var isString: Bool { if case .string = self { return true }; return false }
    var isNumber: Bool {
        switch self {
        case .int, .double: return true
        default: return false
        }
    }
    var isBool: Bool { if case .bool = self { return true }; return false }
    var isNull: Bool { if case .null = self { return true }; return false }
    
    var count: Int? {
        switch self {
        case .array(let arr): return arr.count
        case .dictionary(let dict): return dict.count
        default: return nil
        }
    }
    
    var keys: [String]? {
        if case .dictionary(let dict) = self { return Array(dict.keys) }
        return nil
    }
    
    var values: [JSONValue]? {
        switch self {
        case .dictionary(let dict): return Array(dict.values)
        case .array(let arr): return arr
        default: return nil
        }
    }
}

// MARK: - 值提取方法

extension JSONValue {
    
    var stringValue: String? {
        switch self {
        case .string(let value):
            return value
        case .int(let value):
            return String(value)
        case .double(let value):
            return String(value)
        case .bool(let value):
            return value ? "true" : "false"
        case .dictionary, .array:
            return jsonString
        case .null:
            return nil
        }
    }
    
    var jsonString: String? {
        Self.encodeJSON(self)
    }
    
    var intValue: Int? {
        switch self {
        case .int(let value):
            return value
        case .double(let value):
            guard value.isFinite, value >= Double(Int.min), value <= Double(Int.max) else { return nil }
            return Int(value)
        case .string(let value):
            if let int = Int(value) { return int }
            guard let double = Double(value) else { return nil }
            guard double.isFinite, double >= Double(Int.min), double <= Double(Int.max) else { return nil }
            return Int(double)
        case .bool(let value):
            return value ? 1 : 0
        default:
            return nil
        }
    }
    
    var doubleValue: Double? {
        switch self {
        case .int(let value):
            return Double(value)
        case .double(let value):
            return value
        case .string(let value):
            return Double(value)
        case .bool(let value):
            return value ? 1 : 0
        default:
            return nil
        }
    }
    
    var floatValue: Float? {
        guard let double = doubleValue, double.isFinite else { return nil }
        guard abs(double) <= Double(Float.greatestFiniteMagnitude) else { return nil }
        return Float(double)
    }
    
    var boolValue: Bool? {
        switch self {
        case .bool(let value):
            return value
        case .int(let value):
            if value == 1 { return true }
            if value == 0 { return false }
            return nil
        case .string(let value):
            switch value.lowercased() {
            case "true", "1", "yes": return true
            case "false", "0", "no": return false
            default: return nil
            }
        default:
            return nil
        }
    }
    
    var dictionaryValue: [String: JSONValue]? {
        if case .dictionary(let value) = self { return value }
        return nil
    }
    
    var arrayValue: [JSONValue]? {
        if case .array(let value) = self { return value }
        return nil
    }
    
    var rawValue: Any? {
        switch self {
        case .string(let v): return v
        case .int(let v): return v
        case .double(let v): return v
        case .bool(let v): return v
        case .dictionary(let v): return Dictionary(uniqueKeysWithValues: v.map { ($0.key, $0.value.rawValue as Any) })
        case .array(let v): return v.map { $0.rawValue as Any }
        case .null: return nil
        }
    }

    func formattedString(maxFraction: Int = 2,
                         minFraction: Int = 0,
                         grouping: Bool = false) -> String? {
        guard let number = doubleValue else {
            return stringValue
        }
        return Self.formatNumber(
            number,
            maxFraction: maxFraction,
            minFraction: minFraction,
            grouping: grouping
        )
    }
}

// MARK: - 下标访问

extension JSONValue {
    
    subscript(key: String) -> JSONValue? {
        guard case .dictionary(let dict) = self else { return nil }
        return dict[key]
    }
    
    subscript(key: String, default defaultValue: @autoclosure () -> JSONValue) -> JSONValue {
        self[key] ?? defaultValue()
    }
    
    subscript(index: Int) -> JSONValue? {
        guard case .array(let array) = self else { return nil }
        guard array.indices.contains(index) else { return nil }
        return array[index]
    }
    
    /// 支持负数索引，-1 为最后一个元素
    func at(_ index: Int) -> JSONValue? {
        guard case .array(let array) = self, !array.isEmpty else { return nil }
        let safeIndex = index >= 0 ? index : array.count + index
        guard array.indices.contains(safeIndex) else { return nil }
        return array[safeIndex]
    }
    
    /// 路径访问。支持 `user.address.city`，以及数组下标 `users.0.name`。
    func path(_ keyPath: String) -> JSONValue? {
        let keys = keyPath.split(separator: ".", omittingEmptySubsequences: true).map(String.init)
        var result: JSONValue? = self
        for key in keys {
            guard let current = result else { return nil }
            if let dictValue = current[key] {
                result = dictValue
            } else if let index = Int(key), current.isArray {
                result = current[index]
            } else {
                return nil
            }
        }
        return result
    }
}

// MARK: - 构造

extension JSONValue {
    
    init?(data: Data) {
        guard let value = try? JSONDecoder().decode(JSONValue.self, from: data) else { return nil }
        self = value
    }
    
    init?(jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        self.init(data: data)
    }
}

// MARK: - 私有工具方法

private extension JSONValue {
    
    private static var formatters: [String: NumberFormatter] = [:]
    private static let formatterLock = NSLock()
    private static let encoderLock = NSLock()
    private static let maxFormatterCount = 10
    
    private static let sharedEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()
    
    static func encodeJSON(_ value: JSONValue) -> String? {
        encoderLock.lock()
        defer { encoderLock.unlock() }
        guard let data = try? sharedEncoder.encode(value) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    static func formatNumber(
        _ number: Double,
        maxFraction: Int,
        minFraction: Int,
        grouping: Bool
    ) -> String? {
        let key = "\(maxFraction)_\(minFraction)_\(grouping)"
        
        formatterLock.lock()
        defer { formatterLock.unlock() }
        
        let formatter: NumberFormatter
        if let cached = formatters[key] {
            formatter = cached
        } else {
            if formatters.count >= maxFormatterCount, let firstKey = formatters.keys.first {
                formatters.removeValue(forKey: firstKey)
            }
            let created = NumberFormatter()
            created.minimumFractionDigits = minFraction
            created.maximumFractionDigits = maxFraction
            created.numberStyle = .decimal
            created.decimalSeparator = "."
            if grouping {
                created.usesGroupingSeparator = true
                created.groupingSeparator = ","
                created.groupingSize = 3
                created.locale = Locale(identifier: "en_US_POSIX")
            } else {
                created.usesGroupingSeparator = false
            }
            formatters[key] = created
            formatter = created
        }
        return formatter.string(from: NSNumber(value: number))
    }
}

// MARK: - 字面量初始化

extension JSONValue: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral,
                      ExpressibleByFloatLiteral, ExpressibleByBooleanLiteral,
                      ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral, ExpressibleByNilLiteral {
    
    init(stringLiteral value: String) { self = .string(value) }
    init(integerLiteral value: Int) { self = .int(value) }
    init(floatLiteral value: Double) { self = .double(value) }
    init(booleanLiteral value: Bool) { self = .bool(value) }
    init(nilLiteral: ()) { self = .null }
    
    init(arrayLiteral elements: JSONValue...) { self = .array(elements) }
    
    init(dictionaryLiteral elements: (String, JSONValue)...) {
        var dict: [String: JSONValue] = [:]
        dict.reserveCapacity(elements.count)
        for (key, value) in elements {
            dict[key] = value
        }
        self = .dictionary(dict)
    }
}

// MARK: - Sequence 支持（数组遍历；字典按 key 稳定顺序遍历值）

extension JSONValue: Sequence {
    
    struct Iterator: IteratorProtocol {
        private var iterator: IndexingIterator<[JSONValue]>
        
        init(_ values: [JSONValue]) {
            self.iterator = values.makeIterator()
        }
        
        mutating func next() -> JSONValue? {
            iterator.next()
        }
    }
    
    func makeIterator() -> Iterator {
        switch self {
        case .array(let array):
            return Iterator(array)
        case .dictionary(let dict):
            return Iterator(dict.keys.sorted().compactMap { dict[$0] })
        default:
            return Iterator([])
        }
    }
}
