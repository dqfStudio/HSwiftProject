//
//  HValidationStrategy.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/19.
//  Copyright © 2025 wind. All rights reserved.
//

import Foundation

// 定义验证策略协议
protocol ValidationStrategy {
    func validate(text: String?) -> Bool
}

/*
 用户名称验证
 须是字母与数字的组合，长度6-11位
 */
struct UserNameValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,11}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 密码验证
 字母、数字或其组合，长度6-12位
 */
struct PasswordValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "[a-zA-Z0-9]{6,12}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 是否为空验证
 */
struct EmptyValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        return text?.isEmpty ?? true
    }
}

/*
 纯字母验证
 */
struct OnlyAlphaValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "[a-zA-Z]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 纯数字验证
 */
struct OnlyNumericValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "[0-9]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 字母与数字的组合验证
 默认验证2-10000位
 */
struct AlphaNumericValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 字母、数字或两者的组合验证
 */
struct AlphaOrNumericValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "^[a-zA-Z0-9]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 邮箱验证
 */
struct EmailValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 验证码验证
 */
struct VCodeValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "[0-9]{4,6}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 手机号验证
 */
struct MobileValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        /**
         * 手机号码:
         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 16[6], 17[5, 6, 7, 8], 18[0-9], 170[0-9], 19[89]
         * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705,198
         * 联通号段: 130,131,132,155,156,185,186,145,175,176,1709,166
         * 电信号段: 133,153,180,181,189,177,1700,199
         */
        let MOBILE = "^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$"
        
        let CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)"
        
        let CU = "(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        
        let CT = "(^1(33|53|77|8[019]|99)\\d{8}$)|(^1700\\d{7}$)"
        
        return NSPredicate(format: "SELF MATCHES %@", MOBILE).evaluate(with: text) ||
               NSPredicate(format: "SELF MATCHES %@", CM).evaluate(with: text) ||
               NSPredicate(format: "SELF MATCHES %@", CU).evaluate(with: text) ||
               NSPredicate(format: "SELF MATCHES %@", CT).evaluate(with: text)
    }
}

/*
 身份证号验证
 */
struct IDCardValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 车牌号验证
 */
struct CarNoValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "^[\\u4e00-\\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\\u4e00-\\u9fa5]$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 车型验证
 */
struct CarTypeValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "^[\\u4E00-\\u9FFF]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 纯中文验证
 */
struct OnlyChineseValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "[\\u4e00-\\u9fa5]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 是否有效的微信号验证
 微信号校验 可以使用6—20个字母、数字、下划线和减号，必须以字母开头
 */
struct WechatValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "^[a-zA-Z]([-_a-zA-Z0-9]{5,19})+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 是否有效的银行卡账号验证
 */
struct BankCardValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "[1-9]([0-9]{13,19})"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 是否包含特殊字符验证
 */
struct IllegalCharactersValidationStrategy: ValidationStrategy {
    func validate(text: String?) -> Bool {
        let regex = "^[A-Za-z0-9\\u4e00-\\u9fa5]+$"
        return !NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}

/*
 判断内容长度是否等于某个值
 */
struct LengthEqualToValidationStrategy: ValidationStrategy {
    let length: Int
    
    func validate(text: String?) -> Bool {
        return text?.count == length
    }
}

/*
 判断内容长度是否在某两个值之间
 */
struct LengthBetweenValidationStrategy: ValidationStrategy {
    let start: Int
    let end: Int
    
    func validate(text: String?) -> Bool {
        if let count = text?.count {
            return count >= start && count <= end
        }
        return false
    }
}

// 扩展 HTextField 使用策略模式
extension HTextField {
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
