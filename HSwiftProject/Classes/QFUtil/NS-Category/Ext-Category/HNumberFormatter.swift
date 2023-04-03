//
//  HNumberFormatter.swift
//  HSwiftProject
//
//  Created by Wind on 2023/2/27.
//  Copyright © 2023 wind. All rights reserved.
//

import Foundation

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
    ////清除某些特定符号，是对数据的一种容错处理
    static func clearTheSymbol(_ symbol: String, withText text: String) -> String {
        if !text.isKind(of: NSString.self) {
            return ""
        }
        do {
            let regularExpress: NSRegularExpression = try NSRegularExpression(pattern: symbol, options: .caseInsensitive)
            return regularExpress.stringByReplacingMatches(in: text, options: .reportProgress, range: NSRange(location: 0, length: text.length), withTemplate: "")
        }catch {

        }
        return ""
    }
    //判断是否只有特定符号
    static func isOnlyNumericWithText(_ text: String) -> Bool {
        if !text.isKind(of: NSString.self) {
            return false
        }
        //let regex = "(?=.*[0-9])([0-9+-.,R$￥₫₹])+$"//可以是0-9、+-.,号以及美国 中国 越南 印度等国货币符号，但必须有一位数字
        //let regex = "(?=.*[0-9])([0-9.,])+$"//可以是0-9以及".,"，但必须有一位数字
        let regex = "(?=.*[0-9])([0-9+-.,KMBT￥R$₫₹])+$"//可以是0-9、+-.,号以及美国 中国 越南 印度等国货币符号，但必须有一位数字
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
    static func unFormatter(_ numberObjc:  Any) -> String {

        var stringValue = numberObjc as! String
        if (numberObjc as AnyObject).isKind(of: NSNumber.self) {
            stringValue = (numberObjc as AnyObject).stringValue
        }

        //容错处理
        stringValue = stringValue.replacingOccurrences(of: "。", with: ".")
        stringValue = stringValue.replacingOccurrences(of: "，", with: ",")
        stringValue = stringValue.replacingOccurrences(of: " ", with: "")

        //判断是否是金额数据
        if self.isOnlyNumericWithText(stringValue) {

            //根据地区，去掉分组分隔符
            //不管地区，小数分隔符全部处理成点号
            /*
             let regionArr = ["VN", "BR"]
             if regionArr.containsObject([HUserRegion defaultRegion].regionCode) {
                 stringValue = NSDecimalNumber.clearTheSymbol("[.]", withText: stringValue)
                 stringValue = stringValue.replacingOccurrences(of: ",", with: ".")
             }else {
                 stringValue = NSDecimalNumber.clearTheSymbol("[,]", withText: stringValue)
             }
             */


            //去掉分组分隔符
            stringValue = NSDecimalNumber.clearTheSymbol("[,]", withText: stringValue)
            //去掉正负号
            stringValue = NSDecimalNumber.clearTheSymbol("[+-]", withText: stringValue)
            //去掉一些货币符号
            stringValue = NSDecimalNumber.clearTheSymbol("[R$￥₫₹]", withText: stringValue)

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

            var selfNumber: NSDecimalNumber = NSDecimalNumber(string: stringValue)
            let decimalNumber: NSDecimalNumber = NSDecimalNumber(string: multiplyingString)
            selfNumber = selfNumber.multiplying(by: decimalNumber)

            stringValue = selfNumber.stringValue

            //根据地区显示正确的小数分隔符
            /*
             stringValue = stringValue.replacingOccurrences(of: ".", with: [HUserRegion defaultRegion].decimalSeparator)
             */

            return stringValue

        }

        if (numberObjc as AnyObject).isKind(of: NSNumber.self) {
            stringValue = (numberObjc as AnyObject).stringValue
        }else {
            stringValue = numberObjc as! String
        }

        return stringValue
    }
    //主动操作数据调用
    static func activeDecimalNumberWithObjcValue(_ objcValue: Any, operationMode mode: HOperationMode) -> NSDecimalNumber {
        return NSDecimalNumber.decimalNumberWithObjcValue(objcValue, active: true, operationMode: mode)
    }
    //被动操作数据调用
    static func unactiveDecimalNumberWithObjcValue(_ objcValue: Any, operationMode mode: HOperationMode) -> NSDecimalNumber {
        return NSDecimalNumber.decimalNumberWithObjcValue(objcValue, active: false, operationMode: mode)
    }
    //objcValue为NSString或NSNumber类型
    static func decimalNumberWithObjcValue(_ objcValue: Any, active: Bool, operationMode mode: HOperationMode) -> NSDecimalNumber {
        let objcStringValue: String = NSDecimalNumber.unFormatter(objcValue)
        if self.isOnlyNumericWithText(objcStringValue) {
            return NSDecimalNumber(string: objcStringValue)
        }
        switch (mode) {
        case .adding:
            if active {
                return NSDecimalNumber(string: "0")
            }else {
                return NSDecimalNumber(string: "0")
            }
        case .subtracting:
            if active {
                return NSDecimalNumber(string: "0")
            }else {
                return NSDecimalNumber(string: "0")
            }
        case .multiplying:
            if active {
                return NSDecimalNumber(string: "1")
            }else {
                return NSDecimalNumber(string: "1")
            }
        case .dividing:
            if active {
                return NSDecimalNumber(string: "0")
            }else {
                return NSDecimalNumber(string: "1")
            }
        default:
            break
        }
        return NSDecimalNumber(string: "1")
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

    func numberObjc(_ numberObjc: Any, roundingMode mode: NumberFormatter.RoundingMode, afterPoint: Int, pointZero: Bool, grouping: Bool, prefix: Bool, symbol: String?, conversion: Bool) -> String {

        var decimalNumber = NSDecimalNumber.activeDecimalNumberWithObjcValue(numberObjc, operationMode: .undefine)
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = mode
        numberFormatter.maximumFractionDigits = afterPoint
        //是否保留小数末尾零位
        numberFormatter.minimumFractionDigits = pointZero ? afterPoint : 0
        //分组分隔符，默认为","且每三位进行分割
        if (grouping) {
            numberFormatter.usesGroupingSeparator = grouping
            /*
             numberFormatter.groupingSeparator = [HUserRegion defaultRegion].groupingSeparator
             */

            numberFormatter.groupingSeparator = ","
            numberFormatter.groupingSize = 3
        }
        //小数分隔符，默认为"."
        /*
         numberFormatter.decimalSeparator = [HUserRegion defaultRegion].decimalSeparator
         */

        numberFormatter.decimalSeparator = "."
        //正前缀和负前缀
        if decimalNumber.doubleValue == 0 {
            if symbol != nil, symbol!.length > 0 {
                numberFormatter.positivePrefix = symbol
                numberFormatter.negativePrefix = symbol
            }
        }else if prefix, symbol != nil, symbol!.length > 0 {
            numberFormatter.positivePrefix = "+".appending(symbol!)
            numberFormatter.negativePrefix = "-".appending(symbol!)
        }else if symbol != nil, symbol!.length > 0 {
            numberFormatter.positivePrefix = symbol!
            numberFormatter.negativePrefix = symbol!
        }else if prefix {
            numberFormatter.positivePrefix = "+"
            numberFormatter.negativePrefix = "-"
        }

        //判断是否要金额缩写
        if conversion {

            var tmpString: String
            if (numberObjc as AnyObject).isKind(of: NSNumber.self) {
                tmpString = (numberObjc as! NSNumber).stringValue
            }else {
                tmpString = numberObjc as! String
            }
            /*
             let range = NSString(string: tmpString).range(of: [HUserRegion defaultRegion].decimalSeparator, options: String.CompareOptions.caseInsensitive)
             */

            let range = NSString(string: tmpString).range(of: ".", options: String.CompareOptions.caseInsensitive)
            
            var length = range.location
            if range.location == NSNotFound {
                length = tmpString.length
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
            decimalNumber = decimalNumber.dividingBy(NSDecimalNumber(string: dividendString))
            //正后缀和负后缀
            numberFormatter.positiveSuffix = appendString
            numberFormatter.negativeSuffix = appendString
        }

        return numberFormatter.string(from: decimalNumber)!
    }

}

extension NSNumber {
    //加，value为NSString或NSNumber类型
    func addingBy(_ value: AnyObject) -> NSDecimalNumber {
        let selfNumber: NSDecimalNumber = NSDecimalNumber.activeDecimalNumberWithObjcValue(self, operationMode: .adding)
        let decimalNumber: NSDecimalNumber = NSDecimalNumber.unactiveDecimalNumberWithObjcValue(value, operationMode: .adding)
        return selfNumber.adding(decimalNumber)
    }
    //减，value为NSString或NSNumber类型
    func subtractingBy(_ value: AnyObject) -> NSDecimalNumber {
        let selfNumber: NSDecimalNumber = NSDecimalNumber.activeDecimalNumberWithObjcValue(self, operationMode: .subtracting)
        let decimalNumber: NSDecimalNumber = NSDecimalNumber.unactiveDecimalNumberWithObjcValue(value, operationMode: .subtracting)
        return selfNumber.subtracting(decimalNumber)
    }
    //乘，value为NSString或NSNumber类型
    func multiplyingBy(_ value: AnyObject) -> NSDecimalNumber {
        let selfNumber: NSDecimalNumber = NSDecimalNumber.activeDecimalNumberWithObjcValue(self, operationMode: .multiplying)
        let decimalNumber: NSDecimalNumber = NSDecimalNumber.unactiveDecimalNumberWithObjcValue(value, operationMode: .multiplying)
        return selfNumber.multiplying(by: decimalNumber)
    }
    //除，value为NSString或NSNumber类型
    func dividingBy(_ value: AnyObject) -> NSDecimalNumber {
        let selfNumber: NSDecimalNumber = NSDecimalNumber.activeDecimalNumberWithObjcValue(self, operationMode: .dividing)
        let decimalNumber: NSDecimalNumber = NSDecimalNumber.unactiveDecimalNumberWithObjcValue(value, operationMode: .dividing)
        return selfNumber.dividing(by: decimalNumber)
    }
    //格式化
    func makeFormatter(_ make: (_ make: HNumberFormatter) -> Void) -> String {
        let formatter = HNumberFormatter()
        make(formatter)
        let modeNumber = formatter.formatterEnum[formatter.roundingMode.rawValue] as! NumberFormatter.RoundingMode
        return formatter.numberObjc(self, roundingMode: modeNumber, afterPoint: formatter.afterPoint, pointZero: formatter.pointZero, grouping: formatter.grouping, prefix: formatter.prefix, symbol: formatter.symbol, conversion: formatter.conversion)
    }
    //去格式化
    func makeUnFormatter() -> String {
        return NSDecimalNumber.unFormatter(self)
    }
    //获取十进制金额数据
    func amountValue() -> String {
        return self.makeUnFormatter()
    }
    //带正号的金额数据
    func positiveValue() -> String {
        var stringValue = self.amountValue()
        if stringValue.length > 0 {
            stringValue = "+".appending(stringValue)
        }
        return stringValue
    }
    //带负号的金额数据
    func negativeValue() -> String {
        var stringValue = self.amountValue()
        if stringValue.length > 0 {
            stringValue = "-".appending(stringValue)
        }
        return stringValue
    }
    //带有货币符号的金额数据
    func currencySymbolValue() -> String {
        var stringValue = self.amountValue()
        if stringValue.length > 0 {
            stringValue = HUserRegion.defaultRegion.currencySymbol.appending(stringValue)
        }
        return stringValue
    }
}

extension String {
    //加，value为NSString或NSNumber类型
    func addingBy(_ value: AnyObject) -> NSDecimalNumber {
        let selfNumber: NSDecimalNumber = NSDecimalNumber.activeDecimalNumberWithObjcValue(self, operationMode: .adding)
        let decimalNumber: NSDecimalNumber = NSDecimalNumber.unactiveDecimalNumberWithObjcValue(value, operationMode: .adding)
        return selfNumber.adding(decimalNumber)
    }
    //减，value为NSString或NSNumber类型
    func subtractingBy(_ value: AnyObject) -> NSDecimalNumber {
        let selfNumber: NSDecimalNumber = NSDecimalNumber.activeDecimalNumberWithObjcValue(self, operationMode: .subtracting)
        let decimalNumber: NSDecimalNumber = NSDecimalNumber.unactiveDecimalNumberWithObjcValue(value, operationMode: .subtracting)
        return selfNumber.subtracting(decimalNumber)
    }
    //乘，value为NSString或NSNumber类型
    func multiplyingBy(_ value: AnyObject) -> NSDecimalNumber {
        let selfNumber: NSDecimalNumber = NSDecimalNumber.activeDecimalNumberWithObjcValue(self, operationMode: .multiplying)
        let decimalNumber: NSDecimalNumber = NSDecimalNumber.unactiveDecimalNumberWithObjcValue(value, operationMode: .multiplying)
        return selfNumber.multiplying(by: decimalNumber)
    }
    //除，value为NSString或NSNumber类型
    func dividingBy(_ value: AnyObject) -> NSDecimalNumber {
        let selfNumber: NSDecimalNumber = NSDecimalNumber.activeDecimalNumberWithObjcValue(self, operationMode: .dividing)
        let decimalNumber: NSDecimalNumber = NSDecimalNumber.unactiveDecimalNumberWithObjcValue(value, operationMode: .dividing)
        return selfNumber.dividing(by: decimalNumber)
    }
    //格式化
    func makeFormatter(_ make: (_ make: HNumberFormatter) -> Void) -> String {
        let formatter = HNumberFormatter()
        make(formatter)
        let modeNumber = formatter.formatterEnum[formatter.roundingMode.rawValue] as! NumberFormatter.RoundingMode
        return formatter.numberObjc(self, roundingMode: modeNumber, afterPoint: formatter.afterPoint, pointZero: formatter.pointZero, grouping: formatter.grouping, prefix: formatter.prefix, symbol: formatter.symbol, conversion: formatter.conversion)
    }
    //去格式化
    func makeUnFormatter() -> String {
        return NSDecimalNumber.unFormatter(self)
    }
    //获取十进制金额数据
    func amountValue() -> String {
        return self.makeUnFormatter()
    }
    //带正号的金额数据
    func positiveValue() -> String {
        var stringValue = self.amountValue()
        if stringValue.length > 0 {
            stringValue = "+".appending(stringValue)
        }
        return stringValue
    }
    //带负号的金额数据
    func negativeValue() -> String {
        var stringValue = self.amountValue()
        if stringValue.length > 0 {
            stringValue = "-".appending(stringValue)
        }
        return stringValue
    }
    //带有货币符号的金额数据
    func currencySymbolValue() -> String {
        var stringValue = self.amountValue()
        if stringValue.length > 0 {
            stringValue = HUserRegion.defaultRegion.currencySymbol.appending(stringValue)
        }
        return stringValue
    }
}
