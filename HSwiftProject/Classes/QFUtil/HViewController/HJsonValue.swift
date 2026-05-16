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
    case float(Float)
    case bool(Bool)
    case dictionary([String: JSONValue])
    case array([JSONValue])
    case null
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        switch self {
        case .string(let value):
            return "\"\(value)\""
        case .int(let value):
            return String(value)
        case .double(let value):
            return String(value)
        case .float(let value):
            return String(value)
        case .bool(let value):
            return value ? "true" : "false"
        case .dictionary(let value):
            let pairs = value.map { "\"\($0.key)\": \($0.value.description)" }.joined(separator: ", ")
            return "{\(pairs)}"
        case .array(let value):
            let elements = value.map { $0.description }.joined(separator: ", ")
            return "[\(elements)]"
        case .null:
            return "null"
        }
    }
    
    var debugDescription: String {
        return "JSONValue(\(description))"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 优化解码顺序：先检查 null，再检查 Bool（因为 Bool 在某些 JSON 中可能与数字混淆）
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
            throw DecodingError.typeMismatch(JSONValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to decode JSONValue"))
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
        case .float(let floatValue):
            try container.encode(floatValue)
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
    
    /// 判断是否为数组类型
    var isArray: Bool { if case .array = self { return true }; return false }
    
    /// 判断是否为字典类型
    var isDictionary: Bool { if case .dictionary = self { return true }; return false }
    
    /// 判断是否为字符串类型
    var isString: Bool { if case .string = self { return true }; return false }
    
    /// 判断是否为数字类型
    var isNumber: Bool {
        switch self {
        case .int, .double, .float: return true
        default: return false
        }
    }
    
    /// 判断是否为布尔类型
    var isBool: Bool { if case .bool = self { return true }; return false }
    
    /// 判断是否为 null
    var isNull: Bool { if case .null = self { return true }; return false }
    
    /// 获取数组/字典的元素数量，其他类型返回 nil
    var count: Int? {
        switch self {
        case .array(let arr): return arr.count
        case .dictionary(let dict): return dict.count
        default: return nil
        }
    }
    
    /// 获取字典的所有键
    var keys: [String]? {
        if case .dictionary(let dict) = self { return Array(dict.keys) }
        return nil
    }
    
    /// 获取字典或数组的所有值
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
    
    /// 提取 String 类型的值
    /// 对于字典/数组返回 description
    var stringValue: String? {
        switch self {
        case .string(let value):
            return value
        case .int(let value):
            return String(value)
        case .double(let value):
            return String(value)
        case .float(let value):
            return String(value)
        case .bool(let value):
            return value ? "true" : "false"
        case .dictionary(let value):
            return value.description
        case .array(let value):
            return value.description
        case .null:
            return nil
        }
    }
    
    /// 将 JSONValue 转换为 JSON 格式字符串
    var jsonString: String? {
        return Self.encodeJSON(self)
    }
    
    /// 提取 Int 类型的值
    /// - 注意：从 Double/Float 转换时可能丢失精度或溢出
    var intValue: Int? {
        switch self {
        case .int(let value):
            return value
        case .double(let value):
            // 检查是否在 Int 范围内，避免溢出
            guard value >= Double(Int.min) && value <= Double(Int.max) else { return nil }
            return Int(value)
        case .float(let value):
            guard value >= Float(Int.min) && value <= Float(Int.max) else { return nil }
            return Int(value)
        case .string(let value):
            return Self.isValidNumberString(value) ? Int(value) : nil
        default:
            return nil
        }
    }
    
    /// 提取 Double 类型的值
    var doubleValue: Double? {
        switch self {
        case .int(let value):
            return Double(value)
        case .double(let value):
            return value
        case .float(let value):
            return Double(value)
        case .string(let value):
            return Self.isValidNumberString(value) ? Double(value) : nil
        default:
            return nil
        }
    }
    
    /// 提取 Float 类型的值
    /// - 注意：从 Double 转换时可能丢失精度
    var floatValue: Float? {
        switch self {
        case .int(let value):
            return Float(value)
        case .double(let value):
            // 检查是否在 Float 范围内
            guard value.isFinite && abs(value) <= Double(Float.greatestFiniteMagnitude) else { return nil }
            return Float(value)
        case .float(let value):
            return value
        case .string(let value):
            return Self.isValidNumberString(value) ? Float(value) : nil
        default:
            return nil
        }
    }
    
    /// 提取 Bool 类型的值
    var boolValue: Bool? {
        if case .bool(let value) = self {
            return value
        }
        return nil
    }
    
    /// 提取 Dictionary 类型的值
    var dictionaryValue: [String: JSONValue]? {
        if case .dictionary(let value) = self {
            return value
        }
        return nil
    }
    
    /// 提取 Array 类型的值
    var arrayValue: [JSONValue]? {
        if case .array(let value) = self {
            return value
        }
        return nil
    }
    
    /// 获取原始值（Any 类型）
    var rawValue: Any? {
        switch self {
        case .string(let v): return v
        case .int(let v): return v
        case .double(let v): return v
        case .float(let v): return v
        case .bool(let v): return v
        case .dictionary(let v): return v
        case .array(let v): return v
        case .null: return nil
        }
    }

    /// 格式化数字为字符串
    /// - Parameters:
    ///   - maxFraction: 最大小数位数，默认 2
    ///   - minFraction: 最小小数位数，默认 0
    ///   - grouping: 是否使用千分位分隔符，默认 false
    /// - Returns: 格式化后的字符串
    func formattedString(maxFraction: Int = 2,
                         minFraction: Int = 0,
                         grouping: Bool = false) -> String? {
        guard let number = self.doubleValue else {
            return self.stringValue
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
    
    /// 通过键访问字典值
    subscript(key: String) -> JSONValue? {
        guard case .dictionary(let dict) = self else { return nil }
        return dict[key]
    }
    
    /// 通过键访问字典值，提供默认值
    subscript(key: String, default defaultValue: @autoclosure () -> JSONValue) -> JSONValue {
        return self[key] ?? defaultValue()
    }
    
    /// 通过索引访问数组值
    subscript(index: Int) -> JSONValue? {
        guard case .array(let array) = self else { return nil }
        guard array.indices.contains(index) else { return nil }
        return array[index]
    }
    
    /// 安全获取数组指定索引的值（支持负数索引，-1 表示最后一个元素）
    func at(_ index: Int) -> JSONValue? {
        guard case .array(let array) = self, !array.isEmpty else { return nil }
        let safeIndex = index >= 0 ? index : array.count + index
        guard array.indices.contains(safeIndex) else { return nil }
        return array[safeIndex]
    }
    
    /// 路径访问（支持 "user.address.city" 格式）
    func path(_ keyPath: String) -> JSONValue? {
        let keys = keyPath.split(separator: ".").map(String.init)
        var result: JSONValue? = self
        for key in keys {
            result = result?[key]
        }
        return result
    }
}

// MARK: - 私有工具方法

private extension JSONValue {
    
    /// 缓存的 NumberFormatter（限制最大数量）
    private static var formatters: [String: NumberFormatter] = [:]
    private static let formatterLock = NSLock()
    private static let maxFormatterCount = 10
    
    /// 复用的 JSONEncoder
    private static let sharedEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()
    
    /// 数字字符串匹配的正则表达式（支持负数、小数、科学计数法）
    /// 匹配: 123, -123, 12.34, -12.34, 1e10, 1.5e-3, -1.5E+3
    private static let numberRegex: NSRegularExpression? = {
        let pattern = "^-?(?:\\d+\\.?\\d*|\\d*\\.?\\d+)(?:[eE][+-]?\\d+)?$"
        return try? NSRegularExpression(pattern: pattern)
    }()
    
    /// 判断字符串是否是有效的数字格式
    static func isValidNumberString(_ str: String) -> Bool {
        guard let regex = numberRegex else { return false }
        let range = NSRange(str.startIndex..., in: str)
        return regex.firstMatch(in: str, range: range) != nil
    }
    
    /// 编码 JSON
    static func encodeJSON(_ value: JSONValue) -> String? {
        guard let data = try? sharedEncoder.encode(value) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// 获取或创建缓存的 NumberFormatter
    static func getCachedFormatter(maxFraction: Int, minFraction: Int, grouping: Bool) -> NumberFormatter {
        let key = "\(maxFraction)_\(minFraction)_\(grouping)"
        
        formatterLock.lock()
        defer { formatterLock.unlock() }
        
        if let cached = formatters[key] {
            return cached
        }
        
        // 限制缓存数量，移除最旧的
        if formatters.count >= maxFormatterCount, let firstKey = formatters.keys.first {
            formatters.removeValue(forKey: firstKey)
        }
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = minFraction
        formatter.maximumFractionDigits = maxFraction
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        
        if grouping {
            formatter.usesGroupingSeparator = true
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            formatter.locale = Locale(identifier: "zh_CN")
        } else {
            formatter.usesGroupingSeparator = false
        }
        
        formatters[key] = formatter
        return formatter
    }
    
    /// 格式化数字
    static func formatNumber(
        _ number: Double,
        maxFraction: Int,
        minFraction: Int,
        grouping: Bool
    ) -> String? {
        let formatter = getCachedFormatter(
            maxFraction: maxFraction,
            minFraction: minFraction,
            grouping: grouping
        )
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
        for (key, value) in elements {
            dict[key] = value
        }
        self = .dictionary(dict)
    }
}

// MARK: - Sequence 支持（数组遍历）

extension JSONValue: Sequence {
    
    /// 迭代器类型
    struct Iterator: IteratorProtocol {
        private var iterator: IndexingIterator<[JSONValue]>?
        
        init(_ array: [JSONValue]?) {
            self.iterator = array?.makeIterator()
        }
        
        mutating func next() -> JSONValue? {
            return iterator?.next()
        }
    }
    
    /// 创建迭代器
    func makeIterator() -> Iterator {
        if case .array(let array) = self {
            return Iterator(array)
        }
        return Iterator(nil)
    }
}

// MARK: - ================================================================================
// MARK: - 使用示例：协议扩展实现上下文类型继承与复用
// MARK: - ================================================================================

/*
 ┌─────────────────────────────────────────────────────────────────────────────┐
 │  设计模式：协议 + 默认实现 = "类继承"行为                                      │
 │                                                                             │
 │  核心优势：                                                                   │
 │  1. 通用属性定义一次，所有上下文自动获得                                        │
 │  2. 上下文只需定义差异化逻辑                                                   │
 │  3. 保持 struct 值类型的所有优势                                              │
 │  4. 代码量减少 60% 以上                                                       │
 └─────────────────────────────────────────────────────────────────────────────┘
 */

// MARK: - 示例模型

/*
/// API 用户模型（所有字段使用 JSONValue）
struct APIUser: Codable {
    let id: JSONValue
    let name: JSONValue
    let avatar: JSONValue
    let score: JSONValue
    let level: JSONValue
    let isActive: JSONValue
    let vipType: JSONValue
    let createdAt: JSONValue
}
*/

// MARK: - 协议：定义共享访问能力

/*
/// 用户视图协议 - 提供类型安全的属性访问
protocol UserViewProtocol {
    /// 原始数据源
    var source: APIUser { get }
}

extension UserViewProtocol {
    
    // ========================================
    // MARK: - 类型安全属性（保留原名）
    // ========================================
    // 通过 source 访问原始数据，协议提供转换后的类型安全值
    
    /// 用户 ID
    var id: Int { source.id.intValue ?? 0 }
    
    /// 用户名
    var name: String { source.name.stringValue ?? "匿名用户" }
    
    /// 头像 URL
    var avatar: URL? { URL(string: source.avatar.stringValue ?? "") }
    
    /// 分数
    var score: Double { source.score.doubleValue ?? 0 }
    
    /// 等级
    var level: Int { source.level.intValue ?? 1 }
    
    /// 是否在线
    var isActive: Bool { source.isActive.boolValue ?? false }
    
    // ========================================
    // MARK: - 原始数据访问（命名空间隔离）
    // ========================================
    
    /// 访问原始 JSONValue 数据
    var raw: RawAccessor { RawAccessor(source) }
    
    /// 原始数据访问器
    struct RawAccessor {
        private let source: APIUser
        init(_ source: APIUser) { self.source = source }
        
        var id: JSONValue { source.id }
        var name: JSONValue { source.name }
        var avatar: JSONValue { source.avatar }
        var score: JSONValue { source.score }
        var level: JSONValue { source.level }
        var isActive: JSONValue { source.isActive }
        var vipType: JSONValue { source.vipType }
        var createdAt: JSONValue { source.createdAt }
    }
    
    // ========================================
    // MARK: - 工具方法
    // ========================================
    
    /// 格式化分数
    func formatScore(compact: Bool = false) -> String {
        if compact && score >= 10000 {
            return String(format: "%.1fw", score / 10000)
        }
        return source.score.formattedString(grouping: !compact) ?? "0"
    }
}
*/

// MARK: - 上下文实现

/*
extension APIUser {
    
    // MARK: - 命名空间入口
    
    var list: ListView { ListView(self) }
    var detail: DetailView { DetailView(self) }
    var ranking: RankingView { RankingView(self) }
    
    // ========================================
    // 列表上下文：只定义差异化属性
    // ========================================
    struct ListView: UserViewProtocol {
        let source: APIUser
        init(_ source: APIUser) { self.source = source }
        
        // 重写：截断用户名
        var name: String {
            let n = source.name.stringValue ?? ""
            return n.count > 10 ? String(n.prefix(10)) + "..." : n
        }
        
        // 专用属性
        var scoreText: String { formatScore(compact: true) }
        var levelText: String { "LV.\(level)" }
        var statusDot: String { isActive ? "🟢" : "⚫️" }
        var vipBadge: String? { (source.vipType.intValue ?? 0) > 0 ? "VIP" : nil }
        
        // ========================================
        // 使用方式：
        // ctx.id        → Int（类型安全）
        // ctx.name      → String（重写后截断）
        // ctx.raw.id    → JSONValue（原始数据）
        // ctx.raw.name  → JSONValue（原始数据）
        // ========================================
    }
    
    // ========================================
    // 详情上下文：完整信息展示
    // ========================================
    struct DetailView: UserViewProtocol {
        let source: APIUser
        init(_ source: APIUser) { self.source = source }
        
        // name 使用默认实现（不截断）
        
        // 专用属性
        var scoreText: String { formatScore(compact: false) }
        var levelInfo: String { "LV.\(level) - \(levelTitle)" }
        var joinDate: String { "注册于 \(source.createdAt.stringValue ?? "")" }
        
        private var levelTitle: String {
            switch level {
            case 1...3: return "新手"
            case 4...6: return "进阶"
            case 7...9: return "专家"
            default: return "大师"
            }
        }
    }
    
    // ========================================
    // 排行榜上下文：带排名信息
    // ========================================
    struct RankingView: UserViewProtocol {
        let source: APIUser
        let rank: Int
        let previousRank: Int?
        
        init(_ source: APIUser, rank: Int = 0, previousRank: Int? = nil) {
            self.source = source
            self.rank = rank
            self.previousRank = previousRank
        }
        
        // name 使用默认实现
        
        // 专用属性
        var scoreText: String { formatScore() }
        var rankText: String {
            switch rank {
            case 1: return "🥇"
            case 2: return "🥈"
            case 3: return "🥉"
            default: return "#\(rank)"
            }
        }
        var trendText: String {
            guard let prev = previousRank else { return "NEW" }
            let change = prev - rank
            if change > 0 { return "↑\(change)" }
            if change < 0 { return "↓\(-change)" }
            return "-"
        }
        var isTopThree: Bool { rank >= 1 && rank <= 3 }
    }
}
*/

// MARK: - 使用示例

/*
let jsonData = """
{
    "id": 10086,
    "name": "张三李四王五六七八九",
    "avatar": "https://example.com/avatar.png",
    "score": 12345.67,
    "level": 5,
    "isActive": true,
    "vipType": 2,
    "createdAt": "2024-01-15"
}
""".data(using: .utf8)!

let user = try JSONDecoder().decode(APIUser.self, from: jsonData)

// ========================================
// 列表场景
// ========================================
user.list.id              // 10086（Int - 类型安全）
user.list.name            // "张三李四王五..."（重写：截断）
user.list.score           // 12345.67（Double）
user.list.level           // 5（Int）
user.list.isActive        // true（Bool）
user.list.scoreText       // "1.2w"（专用：简化格式）
user.list.levelText       // "LV.5"（专用属性）
user.list.statusDot       // "🟢"（专用属性）

// 访问原始数据
user.list.raw.id          // JSONValue（原始）
user.list.raw.name        // JSONValue（原始）
user.list.raw.score       // JSONValue（原始）

// ========================================
// 详情场景
// ========================================
user.detail.id            // 10086（Int - 协议默认实现）
user.detail.name          // "张三李四王五六七八九"（协议默认实现：不截断）
user.detail.score         // 12345.67（Double）
user.detail.scoreText     // "12,345.67"（专用：完整格式）
user.detail.levelInfo     // "LV.5 - 进阶"（专用属性）
user.detail.joinDate      // "注册于 2024-01-15"（专用属性）

// 访问原始数据
user.detail.raw.id        // JSONValue（原始）
user.detail.raw.vipType   // JSONValue（原始）

// ========================================
// 排行榜场景
// ========================================
let ranking = user.ranking(rank: 3, previousRank: 5)
ranking.id                // 10086（Int - 协议默认实现）
ranking.name              // "张三李四王五六七八九"（协议默认实现）
ranking.score             // 12345.67（Double）
ranking.scoreText         // "12345.67"（专用属性）
ranking.rankText          // "🥉"（专用属性）
ranking.trendText         // "↑2"（专用属性）
ranking.isTopThree        // true（专用属性）

// ========================================
// 方案 A 优势总结
// ========================================
// ✅ 字段名保持原名：id、name、avatar、score、level、isActive
// ✅ 类型安全访问：ctx.id 直接返回 Int，无需 .intValue ?? 0
// ✅ 原始数据隔离：ctx.raw.id 访问原始 JSONValue
// ✅ 无命名冲突：通过命名空间区分转换值与原始值
// ✅ 语义清晰：value 层是类型安全的，raw 层是原始的
*/

