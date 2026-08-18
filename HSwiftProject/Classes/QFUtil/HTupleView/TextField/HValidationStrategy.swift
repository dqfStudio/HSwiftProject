//
//  HValidationStrategy.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/19.
//  Copyright © 2025 wind. All rights reserved.
//

import Foundation

/*
 验证策略协议
 validate 返回 true 表示通过校验，可与 isValid(using:) 直接对应
 */
protocol ValidationStrategy {
    func validate(text: String?) -> Bool
}

/*
 ASCII 字符集
 表单校验按 0-9 / A-Z a-z 判定，不把全角数字、其他 Unicode 数字算作合法
 */
private enum ValidationCharset {
    static let digits = CharacterSet(charactersIn: "0123456789")
    static let letters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    static let alphanumerics = digits.union(letters)
}

/*
 预编译正则
 使用 \A \z 锚定整串，避免 $ 把末尾换行当成合法结束
 */
private enum ValidationPattern {
    static let email = compile(#"\A[A-Za-z0-9._%+-]+@[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?)*\.[A-Za-z]{2,}\z"#)
    static let mobile = compile(#"\A1[3-9]\d{9}\z"#)
    static let idCard15 = compile(#"\A\d{15}\z"#)
    static let idCard18 = compile(#"\A\d{17}[0-9Xx]\z"#)
    static let carNo = compile(#"\A[\u4e00-\u9fff][A-Z][A-Z0-9]{4,5}[A-Z0-9挂学警港澳\u4e00-\u9fff]\z"#)
    static let onlyChinese = compile(#"\A[\u4e00-\u9fff]+\z"#)
    static let wechat = compile(#"\A[a-zA-Z][-_a-zA-Z0-9]{5,19}\z"#)
    static let legalChars = compile(#"\A[A-Za-z0-9\u4e00-\u9fff]+\z"#)

    private static func compile(_ pattern: String) -> NSRegularExpression {
        try! NSRegularExpression(pattern: pattern)
    }

    static func matches(_ text: String?, _ regex: NSRegularExpression) -> Bool {
        guard let text else { return false }
        let range = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, range: range) else { return false }
        return match.range == range
    }
}

private enum ASCIIClass {
    static func consists(of set: CharacterSet, _ text: String?, min: Int = 1, max: Int = Int.max) -> Bool {
        guard let text else { return false }
        let count = text.count
        guard count >= min, count <= max else { return false }
        return text.unicodeScalars.allSatisfy { set.contains($0) }
    }

    /*
     必须同时包含字母和数字，且只能是两者
     */
    static func mixedAlphanumeric(_ text: String, min: Int, max: Int) -> Bool {
        let count = text.count
        guard count >= min, count <= max else { return false }
        var hasLetter = false
        var hasDigit = false
        for scalar in text.unicodeScalars {
            if ValidationCharset.letters.contains(scalar) {
                hasLetter = true
            } else if ValidationCharset.digits.contains(scalar) {
                hasDigit = true
            } else {
                return false
            }
        }
        return hasLetter && hasDigit
    }
}

private enum CompactText {
    static func trimmed(_ text: String?) -> String? {
        text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

/*
 手机号预处理
 去掉空格、短横，并剥离 +86 / 0086 / 86 国家码
 */
private enum MobileNumber {
    static func normalized(_ text: String?) -> String? {
        guard var value = text?.filter({ !$0.isWhitespace && $0 != "-" }) else { return nil }
        if value.hasPrefix("+86") {
            value.removeFirst(3)
        } else if value.hasPrefix("0086") {
            value.removeFirst(4)
        } else if value.hasPrefix("86"), value.count >= 13 {
            value.removeFirst(2)
        }
        return value
    }
}

/*
 身份证号
 15 位：全数字 + 出生日期
 18 位：出生日期 + GB 11643 校验位
 */
private enum IDCardNumber {
    private static let weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
    private static let checkCodes = ["1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"]

    static func validate(_ text: String?) -> Bool {
        guard let compact = text?.filter({ !$0.isWhitespace }), !compact.isEmpty else { return false }
        if compact.count == 15 {
            guard ValidationPattern.matches(compact, ValidationPattern.idCard15) else { return false }
            return isValidDate(in: compact, is18: false)
        }
        guard compact.count == 18 else { return false }
        guard ValidationPattern.matches(compact, ValidationPattern.idCard18) else { return false }
        guard isValidDate(in: compact, is18: true) else { return false }
        return checksum18(compact)
    }

    private static func isValidDate(in id: String, is18: Bool) -> Bool {
        let chars = Array(id)
        let year: Int
        let month: Int
        let day: Int
        if is18 {
            guard let y = Int(String(chars[6..<10])),
                  let m = Int(String(chars[10..<12])),
                  let d = Int(String(chars[12..<14])) else { return false }
            year = y
            month = m
            day = d
        } else {
            guard let yy = Int(String(chars[6..<8])),
                  let m = Int(String(chars[8..<10])),
                  let d = Int(String(chars[10..<12])) else { return false }
            year = 1900 + yy
            month = m
            day = d
        }
        var comps = DateComponents()
        comps.calendar = Calendar(identifier: .gregorian)
        comps.year = year
        comps.month = month
        comps.day = day
        guard comps.isValidDate else { return false }
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())
        return year >= 1900 && year <= currentYear
    }

    private static func checksum18(_ id: String) -> Bool {
        let chars = Array(id.uppercased())
        var sum = 0
        for i in 0..<17 {
            guard let digit = chars[i].wholeNumberValue else { return false }
            sum += digit * weights[i]
        }
        return String(chars[17]) == checkCodes[sum % 11]
    }
}

/*
 银行卡号
 允许空格、短横分隔；13–19 位纯数字，且通过 Luhn
 */
private enum BankCardNumber {
    static func validate(_ text: String?) -> Bool {
        guard let text else { return false }
        let compact = text.filter { !$0.isWhitespace && $0 != "-" }
        guard (13...19).contains(compact.count) else { return false }
        guard ASCIIClass.consists(of: ValidationCharset.digits, compact) else { return false }
        guard compact.first != "0" else { return false }
        return luhn(compact)
    }

    private static func luhn(_ number: String) -> Bool {
        var sum = 0
        for (index, char) in number.reversed().enumerated() {
            guard let digit = char.wholeNumberValue else { return false }
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }
}

/*
 用户名称验证
 须是字母与数字的组合，长度 6-11 位
 */
struct UserNameValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        guard let text else { return false }
        return ASCIIClass.mixedAlphanumeric(text, min: 6, max: 11)
    }
}

/*
 密码验证
 字母、数字或其组合，长度 6-12 位
 */
struct PasswordValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        return ASCIIClass.consists(of: ValidationCharset.alphanumerics, text, min: 6, max: 12)
    }
}

/*
 非空验证
 nil、空串、纯空白均视为不通过
 */
struct EmptyValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        guard let text = CompactText.trimmed(text) else { return false }
        return !text.isEmpty
    }
}

/*
 纯字母验证
 */
struct OnlyAlphaValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        return ASCIIClass.consists(of: ValidationCharset.letters, text)
    }
}

/*
 纯数字验证
 */
struct OnlyNumericValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        return ASCIIClass.consists(of: ValidationCharset.digits, text)
    }
}

/*
 字母与数字的组合验证
 必须同时包含字母和数字，长度 2-10000 位
 */
struct AlphaNumericValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        guard let text else { return false }
        return ASCIIClass.mixedAlphanumeric(text, min: 2, max: 10000)
    }
}

/*
 字母、数字或两者的组合验证
 */
struct AlphaOrNumericValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        return ASCIIClass.consists(of: ValidationCharset.alphanumerics, text)
    }
}

/*
 邮箱验证
 会去掉首尾空白；顶级域至少 2 个字母
 */
struct EmailValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        return ValidationPattern.matches(CompactText.trimmed(text), ValidationPattern.email)
    }
}

/*
 验证码验证
 4-6 位数字，中间空格会去掉
 */
struct VCodeValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let value = text?.filter { !$0.isWhitespace }
        return ASCIIClass.consists(of: ValidationCharset.digits, value, min: 4, max: 6)
    }
}

/*
 手机号验证
 大陆 11 位，1 开头、第二位 3-9
 支持 +86 / 0086 / 86 前缀
 */
struct MobileValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        return ValidationPattern.matches(MobileNumber.normalized(text), ValidationPattern.mobile)
    }
}

/*
 身份证号验证
 */
struct IDCardValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        return IDCardNumber.validate(text)
    }
}

/*
 车牌号验证
 普通 7 位、新能源 8 位；输入会转大写并去掉空格
 */
struct CarNoValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let value = text?.filter { !$0.isWhitespace }.uppercased()
        return ValidationPattern.matches(value, ValidationPattern.carNo)
    }
}

/*
 车型验证
 须为纯中文
 */
struct CarTypeValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        return ValidationPattern.matches(text, ValidationPattern.onlyChinese)
    }
}

/*
 纯中文验证
 */
struct OnlyChineseValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        return ValidationPattern.matches(text, ValidationPattern.onlyChinese)
    }
}

/*
 微信号验证
 6-20 位，字母开头，其余可为字母、数字、下划线、减号
 */
struct WechatValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        return ValidationPattern.matches(CompactText.trimmed(text), ValidationPattern.wechat)
    }
}

/*
 银行卡账号验证
 */
struct BankCardValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        return BankCardNumber.validate(text)
    }
}

/*
 不含特殊字符验证
 仅允许字母、数字、中文
 空内容视为不含特殊字符，可通过；需要必填时再叠加 EmptyValidationStrategy
 */
struct IllegalCharactersValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        guard let text, !text.isEmpty else { return true }
        return ValidationPattern.matches(text, ValidationPattern.legalChars)
    }
}

/*
 判断内容长度是否等于某个值
 nil 按空串、长度为 0 处理
 */
struct LengthEqualToValidationStrategy: ValidationStrategy {
    let length: Int

    func validate(text: String?) -> Bool {
        return (text ?? "").count == length
    }
}

/*
 判断内容长度是否在某两个值之间
 start / end 顺序无关；nil 按长度为 0 处理
 */
struct LengthBetweenValidationStrategy: ValidationStrategy {
    let start: Int
    let end: Int

    func validate(text: String?) -> Bool {
        let count = (text ?? "").count
        let lower = min(start, end)
        let upper = max(start, end)
        return count >= lower && count <= upper
    }
}

// 扩展 HTextField 使用策略模式
extension HTextField {
    func isValid(using strategy: ValidationStrategy) -> Bool {
        return strategy.validate(text: self.text)
    }
}

// 扩展 HTextFieldView 使用策略模式
extension HTextFieldView {
    func isValid(using strategy: ValidationStrategy) -> Bool {
        return strategy.validate(text: self.text)
    }
}

// 扩展 HTextView 使用策略模式
extension HTextView {
    func isValid(using strategy: ValidationStrategy) -> Bool {
        return strategy.validate(text: self.text)
    }
}
