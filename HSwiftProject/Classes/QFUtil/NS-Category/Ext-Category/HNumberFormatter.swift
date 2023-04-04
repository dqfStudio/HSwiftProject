//
//  HNumberFormatter1.swift
//  HSwiftProject
//
//  Created by Wind on 2021/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

// value           1.2  1.21  1.25  1.35  1.27

// NSRoundPlain    1.2  1.2   1.3   1.4   1.3
// NSRoundDown     1.2  1.2   1.2   1.3   1.2
// NSRoundUp       1.2  1.3   1.3   1.4   1.3
// NSRoundBankers  1.2  1.2   1.2   1.4   1.3

enum HNumberFormatterRoundingMode: Int {
    case roundCeiling = 0
    case roundFloor = 1
    case roundDown = 2
    case roundUp = 3
    case roundHalfEven = 4
    case roundHalfDown = 5
    case roundHalfUp = 6
}

private enum HOperationMode: Int {
    case undefine
    case adding
    case subtracting
    case multiplying
    case dividing
}

private extension NSDecimalNumber {
    //清除某些特定符号，是对数据的一种容错处理
    static func clear(symbol: String, withText text: String) -> String {
        do {
            let regularExpress: NSRegularExpression = try NSRegularExpression(pattern: symbol, options: .caseInsensitive)
            return regularExpress.stringByReplacingMatches(in: text, options: .reportProgress, range: NSRange(location: 0, length: text.count), withTemplate: "")
        }catch {
            return ""
        }
    }
    //判断是否只有特定符号
    static func isOnlyNumeric(withText text: String) -> Bool {
        //let regex = "(?=.*[0-9])([0-9+-.,R$￥₫₹])+$"//可以是0-9、+-.,号以及美国 中国 越南 印度等国货币符号，但必须有一位数字
        //let regex = "(?=.*[0-9])([0-9.,])+$"//可以是0-9以及".,"，但必须有一位数字
        let regex = "(?=.*[0-9])([0-9+-.,KMBT￥R$₫₹])+$"//可以是0-9、+-.,号以及美国 中国 越南 印度等国货币符号，但必须有一位数字
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
    //去格式化
    static func unFormatter(withText text: String) -> String {

        var stringValue = text

        //容错处理
        stringValue = stringValue.replacingOccurrences(of: "。", with: ".")
        stringValue = stringValue.replacingOccurrences(of: "，", with: ",")
        stringValue = stringValue.replacingOccurrences(of: " ", with: "")

        //判断是否是金额数据
        if self.isOnlyNumeric(withText: stringValue) {

            //根据地区，去掉分组分隔符
            //不管地区，小数分隔符全部处理成点号
            /*
             let regionArr = ["VN", "BR"]
             if regionArr.containsObject(HUserRegion.defaultRegion.regionCode) {
                 stringValue = NSDecimalNumber.clear(symbol: "[.]", withText: stringValue)
                 stringValue = stringValue.replacingOccurrences(of: ",", with: ".")
             }else {
                 stringValue = NSDecimalNumber.clear(symbol: "[,]", withText: stringValue)
             }
             */


            //去掉分组分隔符
            stringValue = NSDecimalNumber.clear(symbol: "[,]", withText: stringValue)
            //去掉正负号
            stringValue = NSDecimalNumber.clear(symbol: "[+-]", withText: stringValue)
            //去掉一些货币符号
            stringValue = NSDecimalNumber.clear(symbol: "[R$￥₫₹]", withText: stringValue)

            //金额简写恢复
            var appendString = ""
            var multiplyingString = "1"

            //当达到千、百万、亿、兆时，使用省略写法（K、M、B、T）
            if stringValue.contains("T") {
                appendString = "T"
                multiplyingString = "1000000000000"
            }else if stringValue.contains("B") {
                appendString = "B"
                multiplyingString = "100000000"
            }else if stringValue.contains("M") {
                appendString = "M"
                multiplyingString = "1000000"
            }else if stringValue.contains("K") {
                appendString = "K"
                multiplyingString = "1000"
            }

            stringValue = stringValue.replacingOccurrences(of: appendString, with: "")

            var selfNumber = NSDecimalNumber(string: stringValue)
            let decimalNumber = NSDecimalNumber(string: multiplyingString)
            selfNumber = selfNumber.multiplying(by: decimalNumber)

            stringValue = selfNumber.stringValue

            //根据地区显示正确的小数分隔符
            /*
             stringValue = stringValue.replacingOccurrences(of: ".", with: HUserRegion.defaultRegion.decimalSeparator)
             */

            return stringValue

        }

        return stringValue
    }
    //主动操作数据调用
    static func activeNumber(withText text: String, operationMode mode: HOperationMode) -> NSDecimalNumber {
        return NSDecimalNumber.decimalNumber(withText: text, active: true, operationMode: mode)
    }
    //被动操作数据调用
    static func unactiveNumber(withText text: String, operationMode mode: HOperationMode) -> NSDecimalNumber {
        return NSDecimalNumber.decimalNumber(withText: text, active: false, operationMode: mode)
    }
    static func decimalNumber(withText text: String, active: Bool, operationMode mode: HOperationMode) -> NSDecimalNumber {
        let objcValue = NSDecimalNumber.unFormatter(withText: text)
        if self.isOnlyNumeric(withText: objcValue) {
            return NSDecimalNumber(string: objcValue)
        }
        switch (mode) {
        case .adding:
            if active {
                return NSDecimalNumber.zero
            }else {
                return NSDecimalNumber.zero
            }
        case .subtracting:
            if active {
                return NSDecimalNumber.zero
            }else {
                return NSDecimalNumber.zero
            }
        case .multiplying:
            if active {
                return NSDecimalNumber.one
            }else {
                return NSDecimalNumber.one
            }
        case .dividing:
            if active {
                return NSDecimalNumber.zero
            }else {
                return NSDecimalNumber.one
            }
        default:
            break
        }
        return NSDecimalNumber.one
    }

}

class HNumberFormatter: NSObject {
    //默认roundingMode == roundDown
    var  roundingMode: HNumberFormatterRoundingMode = .roundDown
    //保留几位小数，默认保留两位小数，即afterPoint == 2
    var afterPoint: NSInteger = 2
    //是否强制保留afterPoint位小数，默认为YES
    var pointZero: Bool = true
    //数字是否分组，例如120,354.00，默认为NO
    var grouping: Bool = false
    //是否有"+"或"-"前缀，默认为NO
    var prefix: Bool = false
    //前缀后，数字之前，是否有符号，例如+$234.00，默认为nil
    var symbol: String?
    //当达到千、百万、亿、兆时，使用省略写法（K、M、B、T），默认为NO
    var conversion: Bool = false

    lazy var formatterEnum: NSArray = {
        return [NumberFormatter.RoundingMode.ceiling,
                NumberFormatter.RoundingMode.floor,
                NumberFormatter.RoundingMode.down,
                NumberFormatter.RoundingMode.up,
                NumberFormatter.RoundingMode.halfEven,
                NumberFormatter.RoundingMode.halfDown,
                NumberFormatter.RoundingMode.halfUp]
    }()

    func object(_ objc: String, roundingMode mode: NumberFormatter.RoundingMode, afterPoint: Int, pointZero: Bool, grouping: Bool, prefix: Bool, symbol: String?, conversion: Bool) -> String {

        var decimalNumber = NSDecimalNumber.activeNumber(withText: objc, operationMode: .undefine)
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = mode
        numberFormatter.maximumFractionDigits = afterPoint
        //是否保留小数末尾零位
        numberFormatter.minimumFractionDigits = pointZero ? afterPoint : 0
        //分组分隔符，默认为","且每三位进行分割
        if (grouping) {
            numberFormatter.usesGroupingSeparator = grouping
            /*
             numberFormatter.groupingSeparator = HUserRegion.defaultRegion.groupingSeparator
             */

            numberFormatter.groupingSeparator = ","
            numberFormatter.groupingSize = 3
        }
        //小数分隔符，默认为"."
        /*
         numberFormatter.decimalSeparator = HUserRegion.defaultRegion.decimalSeparator
         */

        numberFormatter.decimalSeparator = "."
        //正前缀和负前缀
        if decimalNumber.doubleValue == 0 {
            if symbol != nil, symbol!.count > 0 {
                numberFormatter.positivePrefix = symbol
                numberFormatter.negativePrefix = symbol
            }
        }else if prefix, symbol != nil, symbol!.count > 0 {
            numberFormatter.positivePrefix = "+".appending(symbol!)
            numberFormatter.negativePrefix = "-".appending(symbol!)
        }else if symbol != nil, symbol!.count > 0 {
            numberFormatter.positivePrefix = symbol!
            numberFormatter.negativePrefix = symbol!
        }else if prefix {
            numberFormatter.positivePrefix = "+"
            numberFormatter.negativePrefix = "-"
        }

        //判断是否要金额缩写
        if conversion {

            /*
             let range = NSString(string: objc).range(of: HUserRegion.defaultRegion.decimalSeparator, options: String.CompareOptions.caseInsensitive)
             */

            let range = NSString(string: objc).range(of: ".", options: String.CompareOptions.caseInsensitive)

            var length = range.location
            if range.location == NSNotFound {
                length = objc.count
            }

            var appendString = ""
            var dividendString = "1"

            //当达到千、百万、亿、兆时，使用省略写法（K、M、B、T）
            if length >= 13 {
                appendString = "T"
                dividendString = "1000000000000"
            }else if length >= 9 {
                appendString = "B"
                dividendString = "100000000"
            }else if length >= 7 {
                appendString = "M"
                dividendString = "1000000"
            }else if length >= 4 {
                appendString = "K"
                dividendString = "1000"
            }
            //除以相关位数
            decimalNumber = decimalNumber.dividing(by: NSDecimalNumber(string: dividendString))
            //正后缀和负后缀
            numberFormatter.positiveSuffix = appendString
            numberFormatter.negativeSuffix = appendString
        }

        return numberFormatter.string(from: decimalNumber)!
    }

}

extension String {
    //加，value为NSString类型
    func addingBy(_ value: String) -> String {
        let activeNumber = NSDecimalNumber.activeNumber(withText: self, operationMode: .adding)
        let unactiveNumber = NSDecimalNumber.unactiveNumber(withText: value, operationMode: .adding)
        return activeNumber.adding(unactiveNumber).stringValue
    }
    //减，value为NSString类型
    func subtractingBy(_ value: String) -> String {
        let activeNumber = NSDecimalNumber.activeNumber(withText: self, operationMode: .subtracting)
        let unactiveNumber = NSDecimalNumber.unactiveNumber(withText: value, operationMode: .subtracting)
        return activeNumber.subtracting(unactiveNumber).stringValue
    }
    //乘，value为NSString类型
    func multiplyingBy(_ value: String) -> String {
        let activeNumber = NSDecimalNumber.activeNumber(withText: self, operationMode: .multiplying)
        let unactiveNumber = NSDecimalNumber.unactiveNumber(withText: value, operationMode: .multiplying)
        return activeNumber.multiplying(by: unactiveNumber).stringValue
    }
    //除，value为NSString类型
    func dividingBy(_ value: String) -> String {
        let activeNumber = NSDecimalNumber.activeNumber(withText: self, operationMode: .dividing)
        let unactiveNumber = NSDecimalNumber.unactiveNumber(withText: value, operationMode: .dividing)
        return activeNumber.dividing(by: unactiveNumber).stringValue
    }
    //格式化
    func formatter(_ make: (_ make: HNumberFormatter) -> Void) -> String {
        let formatter = HNumberFormatter()
        make(formatter)
        let modeNumber = formatter.formatterEnum[formatter.roundingMode.rawValue] as! NumberFormatter.RoundingMode
        return formatter.object(self, roundingMode: modeNumber, afterPoint: formatter.afterPoint, pointZero: formatter.pointZero, grouping: formatter.grouping, prefix: formatter.prefix, symbol: formatter.symbol, conversion: formatter.conversion)
    }
    //去格式化
    func unFormatter() -> String {
        return NSDecimalNumber.unFormatter(withText: self)
    }
    //获取十进制金额数据
    func amountValue() -> String {
        return self.unFormatter()
    }
    //带正号的金额数据
    func positiveValue() -> String {
        var stringValue = self.amountValue()
        if stringValue.count > 0 {
            stringValue = "+".appending(stringValue)
        }
        return stringValue
    }
    //带负号的金额数据
    func negativeValue() -> String {
        var stringValue = self.amountValue()
        if stringValue.count > 0 {
            stringValue = "-".appending(stringValue)
        }
        return stringValue
    }
    //带有货币符号的金额数据
    func currencySymbolValue() -> String {
        var stringValue = self.amountValue()
        if stringValue.count > 0 {
            stringValue = HUserRegion.defaultRegion.currencySymbol.appending(stringValue)
        }
        return stringValue
    }
}

extension NSNumber {
    //加，value为NSNumber类型
    func addingBy(_ value: NSNumber) -> String {
        return self.stringValue.addingBy(value.stringValue)
    }
    //减，value为NSNumber类型
    func subtractingBy(_ value: NSNumber) -> String {
        return self.stringValue.subtractingBy(value.stringValue)
    }
    //乘，value为NSNumber类型
    func multiplyingBy(_ value: NSNumber) -> String {
        return self.stringValue.multiplyingBy(value.stringValue)
    }
    //除，value为NSNumber类型
    func dividingBy(_ value: NSNumber) -> String {
        return self.stringValue.dividingBy(value.stringValue)
    }
    //格式化
    func formatter(_ make: (_ make: HNumberFormatter) -> Void) -> String {
        return self.stringValue.formatter(make)
    }
    //去格式化
    func unFormatter() -> String {
        return self.stringValue.unFormatter()
    }
    //获取十进制金额数据
    func amountValue() -> String {
        return self.stringValue.amountValue()
    }
    //带正号的金额数据
    func positiveValue() -> String {
        return self.stringValue.positiveValue()
    }
    //带负号的金额数据
    func negativeValue() -> String {
        return self.stringValue.negativeValue()
    }
    //带有货币符号的金额数据
    func currencySymbolValue() -> String {
        return self.stringValue.currencySymbolValue()
    }
}
