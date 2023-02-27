//
//  HNumberFormatter.swift
//  HSwiftProject
//
//  Created by owner on 2023/2/27.
//  Copyright © 2023 wind. All rights reserved.
//

import Foundation

enum HNumberFormatterRoundingMode: Int {
//    typealias RawValue = <#type#>
    
//    case roundCeiling = NumberFormatter.RoundingMode.ceiling
//    case roundFloor = NumberFormatter.RoundingMode.floor
//    case roundDown = .roundDown
//    case roundUp = .roundUp
//    case roundHalfEven = .roundHalfEven
//    case roundHalfDown = .roundHalfDown
//    case roundHalfUp = .roundHalfUp
    
    case roundCeiling = .roundCeiling
    case roundFloor = .roundFloor
    case roundDown = .roundDown
    case roundUp = .roundUp
    case roundHalfEven = .roundHalfEven
    case roundHalfDown = .roundHalfDown
    case roundHalfUp = .roundHalfUp
}

private enum HOperationMode: Int {
    case undefine
    case adding
    case subtracting
    case multiplying
    case dividing
}

//typedef NS_ENUM(NSUInteger, HOperationMode) {
//    other,
//    adding,
//    subtracting,
//    multiplying,
//    dividing
//};

//typedef NS_ENUM(NSUInteger, HNumberFormatterRoundingMode) {
//    case roundCeiling = NSNumberFormatterRoundCeiling,
//    case roundFloor = NSNumberFormatterRoundFloor,
//    case roundDown = NSNumberFormatterRoundDown,
//    case roundUp = NSNumberFormatterRoundUp,
//    case roundHalfEven = NSNumberFormatterRoundHalfEven,
//    case roundHalfDown = NSNumberFormatterRoundHalfDown,
//    case roundHalfUp = NSNumberFormatterRoundHalfUp
//};

//NS_ASSUME_NONNULL_BEGIN

//class HNumberFormatter : NSObject {
//    @interface HNumberFormatter : NSObject
//    //默认roundingMode == roundDown
//    @property(nonatomic, assign) HNumberFormatterRoundingMode roundingMode;
//    //保留几位小数，默认保留两位小数，即afterPoint == 2
//    @property(nonatomic, assign) NSInteger afterPoint;
//    //是否强制保留afterPoint位小数，默认为YES
//    @property(nonatomic, assign) BOOL pointZero;
//    //数字是否分组，例如120,354.00，默认为NO
//    @property(nonatomic, assign) BOOL grouping;
//    //是否有"+"或"-"前缀，默认为NO
//    @property(nonatomic, assign) BOOL prefix;
//    //前缀后，数字之前，是否有符号，例如+$234.00，默认为nil
//    @property(nonatomic) NSString *symbol;
//    //当达到千、百万、亿、兆时，使用省略写法（K、M、B、T），默认为NO
//    @property(nonatomic, assign) BOOL conversion;
    //@end
//}

//extension NSNumber {
//    @interface NSNumber (HFormatter)
//    //加，value为NSString或NSNumber类型
//    - (NSDecimalNumber *)adding:(id)value;
//    //减，value为NSString或NSNumber类型
//    - (NSDecimalNumber *)subtracting:(id)value;
//    //乘，value为NSString或NSNumber类型
//    - (NSDecimalNumber *)multiplying:(id)value;
//    //除，value为NSString或NSNumber类型
//    - (NSDecimalNumber *)dividing:(id)value;
//    //获取十进制金额数据
//    - (NSString *)amountValue;
//    //带正号的金额数据
//    - (NSString *)positiveValue;
//    //带负号的金额数据
//    - (NSString *)negativeValue;
//    //带有货币符号的金额数据
//    - (NSString *)currencySymbolValue;
//    //格式化
//    - (NSString *)makeFormatter:(void(^_Nullable)(HNumberFormatter *make))block;
//    @end
//}

//extension NSString {
//    @interface NSString (HFormatter)
//    //加，value为NSString或NSNumber类型
//    - (NSDecimalNumber *)adding:(id)value;
//    //减，value为NSString或NSNumber类型
//    - (NSDecimalNumber *)subtracting:(id)value;
//    //乘，value为NSString或NSNumber类型
//    - (NSDecimalNumber *)multiplying:(id)value;
//    //除，value为NSString或NSNumber类型
//    - (NSDecimalNumber *)dividing:(id)value;
//    //获取十进制金额数据
//    - (NSString *)amountValue;
//    //带正号的金额数据
//    - (NSString *)positiveValue;
//    //带负号的金额数据
//    - (NSString *)negativeValue;
//    //带有货币符号的金额数据
//    - (NSString *)currencySymbolValue;
//    //格式化
//    - (NSString *)makeFormatter:(void(^_Nullable)(HNumberFormatter *make))block;
//    @end
//}
//NS_ASSUME_NONNULL_END




//#import "HNumberFormatter.h"

//typedef NS_ENUM(NSUInteger, HOperationMode) {
//    other,
//    adding,
//    subtracting,
//    multiplying,
//    dividing
//};

private extension NSDecimalNumber {
    ////清除某些特定符号，是对数据的一种容错处理
    static func clearTheSymbol(_ symbol: String, withText text: String) -> String {
        if !text.isKind(of: NSString.self) {
            return ""
        }
        do {
            let regularExpress: NSRegularExpression = try NSRegularExpression.init(pattern: symbol, options: .caseInsensitive)
            return regularExpress.stringByReplacingMatches(in: text, options: .reportProgress, range: NSMakeRange(0, text.length), withTemplate: "")
        }catch {
            
        }
        return ""
    }
    //判断是否只有特定符号
    static func isOnlyNumericWithText(_ text: String) -> Bool {
        if !text.isKind(of: NSString.self) {
            return false
        }
        //let regex = "(?=.*[0-9])([0-9+-.,R$￥₫₹])+$";//可以是0-9、+-.,号以及美国 中国 越南 印度等国货币符号，但必须有一位数字
        //let regex = "(?=.*[0-9])([0-9.,])+$";//可以是0-9以及".,"，但必须有一位数字
        let regex = "(?=.*[0-9])([0-9+-.,KMBT￥R$₫₹])+$";//可以是0-9、+-.,号以及美国 中国 越南 印度等国货币符号，但必须有一位数字
        return NSPredicate.init(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
    static func unFormatter(_ numberObjc:  AnyObject) -> String {
        
        var stringValue: String = numberObjc as! String
        if numberObjc.isKind(of: NSNumber.self) {
            stringValue = numberObjc.stringValue
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
            
            var selfNumber: NSDecimalNumber = NSDecimalNumber.init(string: stringValue)
            let decimalNumber: NSDecimalNumber = NSDecimalNumber.init(string: multiplyingString)
            selfNumber = selfNumber.multiplying(by: decimalNumber)
            
            stringValue = selfNumber.stringValue
            
            //根据地区显示正确的小数分隔符
            /*
             stringValue = stringValue.replacingOccurrences(of: ".", with: [HUserRegion defaultRegion].decimalSeparator)
             */
            
            return stringValue
            
        }

        if numberObjc.isKind(of: NSNumber.self) {
            stringValue = numberObjc.stringValue
        }else {
            stringValue = numberObjc as! String
        }
        
        return stringValue
    }
    //主动操作数据调用
    static func activeDecimalNumberWithObjcValue(_ objcValue: AnyObject, operationMode mode: HOperationMode) -> NSDecimalNumber {
        return NSDecimalNumber.decimalNumberWithObjcValue(objcValue, active: true, operationMode: mode)
    }
    //被动操作数据调用
    static func unactiveDecimalNumberWithObjcValue(_ objcValue: AnyObject, operationMode mode: HOperationMode) -> NSDecimalNumber {
        return NSDecimalNumber.decimalNumberWithObjcValue(objcValue, active: false, operationMode: mode)
    }
    //objcValue为NSString或NSNumber类型
    static func decimalNumberWithObjcValue(_ objcValue: AnyObject, active: Bool, operationMode mode: HOperationMode) {
        let objcStringValue: NSString  = NSDecimalNumber.unFormatter(objcValue)
        if self.isOnlyNumericWithText(objcStringValue) {
            return NSDecimalNumber.init(string: objcStringValue)
        }
        switch (mode) {
        case adding: {
            if (active) return NSDecimalNumber.init(string: "0")
            else return NSDecimalNumber.init(string: "0")
        }
            break;
        case subtracting: {
            if (active) return NSDecimalNumber.init(string: "0")
            else return NSDecimalNumber.init(string: "0")
        }
            break;
        case multiplying: {
            if (active) return NSDecimalNumber.init(string: "1")
            else return NSDecimalNumber.init(string: "1")
        }
            break;
        case dividing: {
            if (active) return NSDecimalNumber.init(string: "0")
            else return NSDecimalNumber.init(string: "1")
        }
            break;
            
        default:
            break;
        }
        return nil;
    }
    
}

//@implementation HNumberFormatter

class HNumberFormatter: NSObject {
    //默认roundingMode == roundDown
    @property(nonatomic, assign) HNumberFormatterRoundingMode roundingMode;
    //保留几位小数，默认保留两位小数，即afterPoint == 2
    @property(nonatomic, assign) NSInteger afterPoint;
    //是否强制保留afterPoint位小数，默认为YES
    @property(nonatomic, assign) BOOL pointZero;
    //数字是否分组，例如120,354.00，默认为NO
    @property(nonatomic, assign) BOOL grouping;
    //是否有"+"或"-"前缀，默认为NO
    @property(nonatomic, assign) BOOL prefix;
    //前缀后，数字之前，是否有符号，例如+$234.00，默认为nil
    @property(nonatomic) NSString *symbol;
    //当达到千、百万、亿、兆时，使用省略写法（K、M、B、T），默认为NO
    @property(nonatomic, assign) BOOL conversion;
    
    - (instancetype)init {
        self = [super init];
        if (self) {
            _roundingMode = roundDown;
            _afterPoint = 2;
            _pointZero = YES;
            _grouping = NO;
            _prefix = NO;
            _symbol = nil;
            _conversion = NO;
        }
        return self;
    }
    
    - (NSArray *(^)(void))formatterEnum {
        return ^NSArray *(void) {
            static dispatch_once_t once;
            static NSArray *array;
            dispatch_once(&once, ^{
                array = @[@(NSNumberFormatterRoundCeiling),
                          @(NSNumberFormatterRoundFloor),
                          @(NSNumberFormatterRoundDown),
                          @(NSNumberFormatterRoundUp),
                          @(NSNumberFormatterRoundHalfEven),
                          @(NSNumberFormatterRoundHalfDown),
                          @(NSNumberFormatterRoundHalfUp)];
            });
            return array;
        };
    }
    
    - (NSString *)numberObjc:(id)numberObjc
    roundingMode:(NSNumberFormatterRoundingMode)mode
    afterPoint:(NSInteger)position
    pointZero:(BOOL)pointZero
    grouping:(BOOL)grouping
        prefix:(BOOL)prefix
    symbol:(NSString *)symbol
    conversion:(BOOL)conversion {
        
        NSDecimalNumber *decimalNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:numberObjc operationMode:undefine];
        if (!decimalNumber) return numberObjc;
        
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        numberFormatter.roundingMode = mode;
        numberFormatter.maximumFractionDigits = position;
        //是否保留小数末尾零位
        numberFormatter.minimumFractionDigits = pointZero ? position : 0;
        //分组分隔符，默认为","且每三位进行分割
        if (grouping) {
            numberFormatter.usesGroupingSeparator = grouping;
            /*
             numberFormatter.groupingSeparator = [HUserRegion defaultRegion].groupingSeparator;
             */
            
            numberFormatter.groupingSeparator = @",";
            numberFormatter.groupingSize = 3;
        }
        //小数分隔符，默认为"."
        /*
         numberFormatter.decimalSeparator = [HUserRegion defaultRegion].decimalSeparator;
         */
        
        numberFormatter.decimalSeparator = @".";
        //正前缀和负前缀
        if (decimalNumber.doubleValue == 0) {
            if (symbol.length > 0) {
                numberFormatter.positivePrefix = symbol;
                numberFormatter.negativePrefix = symbol;
            }
        }else if (prefix && symbol.length > 0) {
            numberFormatter.positivePrefix = [@"+" stringByAppendingString:symbol];
            numberFormatter.negativePrefix = [@"-" stringByAppendingString:symbol];
        }else if (symbol.length > 0) {
            numberFormatter.positivePrefix = symbol;
            numberFormatter.negativePrefix = symbol;
        }else if (prefix) {
            numberFormatter.positivePrefix = @"+";
            numberFormatter.negativePrefix = @"-";
        }
        
        //判断是否要金额缩写
        if (conversion) {
            
            NSString *tmpString = numberObjc;
            if ([numberObjc isKindOfClass:NSNumber.class]) {
                tmpString = [(NSNumber *)numberObjc stringValue];
            }
            /*
             NSRange range = [tmpString rangeOfString:[HUserRegion defaultRegion].decimalSeparator];
             */
            
            NSRange range = [tmpString rangeOfString:@"."];
            NSInteger length = range.location;
            if (range.location == NSNotFound) length = tmpString.length;
            
            NSString *appendString = @"";
            NSString *dividendString = @"1";
            
            //当达到千、百万、亿、兆时，使用省略写法（K、M、B、T）
            if (length >= 13) {
                appendString = @"T";
                dividendString = @"1000000000000";
            }else if (length >= 9) {
                appendString = @"B";
                dividendString = @"100000000";
            }else if (length >= 7) {
                appendString = @"M";
                dividendString = @"1000000";
            }else if (length >= 4) {
                appendString = @"K";
                dividendString = @"1000";
            }
            //除以相关位数
            decimalNumber = [decimalNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:dividendString]];
            //正后缀和负后缀
            numberFormatter.positiveSuffix = appendString;
            numberFormatter.negativeSuffix = appendString;
        }
        
        return [numberFormatter stringFromNumber:decimalNumber];
    }
    
    //@end
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
//    - (NSString *)makeFormatter:(void(^_Nullable)(HNumberFormatter *make))block {
//        HNumberFormatter *make = HNumberFormatter.new;
//        if (block) block(make);
//        NSNumber *modeNumber = make.formatterEnum()[make.roundingMode];
//        return [make numberObjc:self roundingMode:modeNumber.intValue afterPoint:make.afterPoint pointZero:make.pointZero grouping:make.grouping prefix:make.prefix symbol:make.symbol conversion:make.conversion];
//    }
    func makeFormatter(@convention(c)(Any,HNumberFormatter)->Void) -> String {
        self.makeUnFormatter()
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
        let stringValue = self.amountValue()
        if stringValue.length > 0 {
            stringValue = "+".appending(stringValue)
        }
        return stringValue
    }
    //带负号的金额数据
    func negativeValue() -> String {
        let stringValue = self.amountValue()
        if stringValue.length > 0 {
            stringValue = "-".appending(stringValue)
        }
        return stringValue
    }
    //带有货币符号的金额数据
    func currencySymbolValue() -> String {
        let stringValue = self.amountValue()
        if stringValue.length > 0 {
            stringValue = [HUserRegion defaultRegion].currencySymbol.appending(stringValue)
        }
        return stringValue
    }
}

extension NSString {
    
    //加，value为NSString或NSNumber类型
    - (NSDecimalNumber *)adding:(id)value;
    //减，value为NSString或NSNumber类型
    - (NSDecimalNumber *)subtracting:(id)value;
    //乘，value为NSString或NSNumber类型
    - (NSDecimalNumber *)multiplying:(id)value;
    //除，value为NSString或NSNumber类型
    - (NSDecimalNumber *)dividing:(id)value;
    //获取十进制金额数据
    - (NSString *)amountValue;
    //带正号的金额数据
    - (NSString *)positiveValue;
    //带负号的金额数据
    - (NSString *)negativeValue;
    //带有货币符号的金额数据
    - (NSString *)currencySymbolValue;
    //格式化
    - (NSString *)makeFormatter:(void(^_Nullable)(HNumberFormatter *make))block;
    
    
    @implementation NSString (HFormatter)
    //加，value为NSString或NSNumber类型
    - (NSDecimalNumber *)adding:(id)value {
        NSDecimalNumber *selfNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:self operationMode:adding];
        NSDecimalNumber *decimalNumber = [NSDecimalNumber unactiveDecimalNumberWithObjcValue:value operationMode:adding];
        return [selfNumber decimalNumberByAdding:decimalNumber];
    }
    //减，value为NSString或NSNumber类型
    - (NSDecimalNumber *)subtracting:(id)value {
        NSDecimalNumber *selfNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:self operationMode:subtracting];
        NSDecimalNumber *decimalNumber = [NSDecimalNumber unactiveDecimalNumberWithObjcValue:value operationMode:subtracting];
        return [selfNumber decimalNumberBySubtracting:decimalNumber];
    }
    //乘，value为NSString或NSNumber类型
    - (NSDecimalNumber *)multiplying:(id)value {
        NSDecimalNumber *selfNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:self operationMode:multiplying];
        NSDecimalNumber *decimalNumber = [NSDecimalNumber unactiveDecimalNumberWithObjcValue:value operationMode:multiplying];
        return [selfNumber decimalNumberByMultiplyingBy:decimalNumber];
    }
    //除，value为NSString或NSNumber类型
    - (NSDecimalNumber *)dividing:(id)value {
        NSDecimalNumber *selfNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:self operationMode:dividing];
        NSDecimalNumber *decimalNumber = [NSDecimalNumber unactiveDecimalNumberWithObjcValue:value operationMode:dividing];
        return [selfNumber decimalNumberByDividingBy:decimalNumber];
    }
    //格式化
    - (NSString *)makeFormatter:(void(^_Nullable)(HNumberFormatter *make))block {
        HNumberFormatter *make = HNumberFormatter.new;
        if (block) block(make);
        NSNumber *modeNumber = make.formatterEnum()[make.roundingMode];
        return [make numberObjc:self roundingMode:modeNumber.intValue afterPoint:make.afterPoint pointZero:make.pointZero grouping:make.grouping prefix:make.prefix symbol:make.symbol conversion:make.conversion];
    }
    //去格式化
    - (NSString *)makeUnFormatter {
        return [NSDecimalNumber unFormatter:self];
    }
    //获取十进制金额数据
    - (NSString *)amountValue {
        return self.makeUnFormatter;
    }
    //带正号的金额数据
    - (NSString *)positiveValue {
        NSString *stringValue = self.amountValue;
        if (stringValue.length > 0) {
            stringValue = [@"+" stringByAppendingString:stringValue];
        }
        return stringValue;
    }
    //带负号的金额数据
    - (NSString *)negativeValue {
        NSString *stringValue = self.amountValue;
        if (stringValue.length > 0) {
            stringValue = [@"-" stringByAppendingString:stringValue];
        }
        return stringValue;
    }
    //带有货币符号的金额数据
    - (NSString *)currencySymbolValue {
        NSString *stringValue = self.amountValue;
        if (stringValue.length > 0) {
            stringValue = [[HUserRegion defaultRegion].currencySymbol stringByAppendingString:stringValue];
        }
        return stringValue;
    }
    @end
}
