//
//  HNumberFormatter.m
//  QFProj
//
//  Created by dqf on 2021/4/30.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HNumberFormatter.h"

typedef NS_ENUM(NSUInteger, HOperationMode) {
    other,
    adding,
    subtracting,
    multiplying,
    dividing
};

@implementation NSDecimalNumber (HFormatter)
////清除某些特定符号，是对数据的一种容错处理
+ (NSString *)clearTheSymbol:(NSString *)symbol withText:(NSString *)text {
    if (![text isKindOfClass:NSString.class]) return @"";
    NSRegularExpression *regularExpress = [NSRegularExpression regularExpressionWithPattern:symbol options:0 error:nil];
    return [regularExpress stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
}
//判断是否只有特定符号
+ (BOOL)isOnlyNumericWithText:(NSString *)text {
    if (![text isKindOfClass:NSString.class]) return NO;
    //NSString *regex = @"(?=.*[0-9])([0-9+-.,R$￥₫₹])+$";//可以是0-9、+-.,号以及美国 中国 越南 印度等国货币符号，但必须有一位数字
    //NSString *regex = @"(?=.*[0-9])([0-9.,])+$";//可以是0-9以及".,"，但必须有一位数字
    NSString *regex = @"(?=.*[0-9])([0-9+-.,KMBT￥R$₫₹])+$";//可以是0-9、+-.,号以及美国 中国 越南 印度等国货币符号，但必须有一位数字
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:text];
}
+ (NSString *)unFormatter:(id)numberObjc {
    
    NSString *stringValue = numberObjc;
    if ([numberObjc isKindOfClass:NSNumber.class]) {
        stringValue = [(NSNumber *)numberObjc stringValue];
    }
    
    //容错处理
    stringValue = [stringValue stringByReplacingOccurrencesOfString:@"。" withString:@"."];
    stringValue = [stringValue stringByReplacingOccurrencesOfString:@"，" withString:@","];
    stringValue = [stringValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //判断是否是金额数据
    if ([self isOnlyNumericWithText:stringValue]) {
     
        //根据地区，去掉分组分隔符
        //不管地区，小数分隔符全部处理成点号
        /*
        NSArray *regionArr = @[@"VN", @"BR"];
        if ([regionArr containsObject:[HUserRegion defaultRegion].regionCode]) {
            stringValue = [NSDecimalNumber clearTheSymbol:@"[.]" withText:stringValue];
            stringValue = [stringValue stringByReplacingOccurrencesOfString:@"," withString:@"."];
        }else {
            stringValue = [NSDecimalNumber clearTheSymbol:@"[,]" withText:stringValue];
        }
         */
        

        //去掉分组分隔符
        stringValue = [NSDecimalNumber clearTheSymbol:@"[,]" withText:stringValue];
        //去掉正负号
        stringValue = [NSDecimalNumber clearTheSymbol:@"[+-]" withText:stringValue];
        //去掉一些货币符号
        stringValue = [NSDecimalNumber clearTheSymbol:@"[R$￥₫₹]" withText:stringValue];

        //金额简写恢复
        NSString *appendString = @"";
        NSString *multiplyingString = @"1";
        
        //当达到千、百万、亿、兆时，使用省略写法（K、M、B、T）
        if ([stringValue containsString:@"T"]) {
            appendString = @"T";
            multiplyingString = @"1000000000000";
        }else if ([stringValue containsString:@"B"]) {
            appendString = @"B";
            multiplyingString = @"100000000";
        }else if ([stringValue containsString:@"M"]) {
            appendString = @"M";
            multiplyingString = @"1000000";
        }else if ([stringValue containsString:@"K"]) {
            appendString = @"K";
            multiplyingString = @"1000";
        }
        
        stringValue = [stringValue stringByReplacingOccurrencesOfString:appendString withString:@""];
        
        NSDecimalNumber *selfNumber = [NSDecimalNumber decimalNumberWithString:stringValue];
        NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:multiplyingString];
        selfNumber = [selfNumber decimalNumberByMultiplyingBy:decimalNumber];
        
        stringValue = selfNumber.stringValue;
        
        //根据地区显示正确的小数分隔符
        /*
         stringValue = [stringValue stringByReplacingOccurrencesOfString:@"." withString:[HUserRegion defaultRegion].decimalSeparator];
        */
        
        return stringValue;
        
    }
    
    stringValue = numberObjc;
    if ([numberObjc isKindOfClass:NSNumber.class]) {
        stringValue = [(NSNumber *)numberObjc stringValue];
    }
    return stringValue;
}
//主动操作数据调用
+ (NSDecimalNumber *)activeDecimalNumberWithObjcValue:(id)objcValue operationMode:(HOperationMode)mode {
    return [NSDecimalNumber decimalNumberWithObjcValue:objcValue active:YES operationMode:mode];
}
//被动操作数据调用
+ (NSDecimalNumber *)unactiveDecimalNumberWithObjcValue:(id)objcValue operationMode:(HOperationMode)mode {
    return [NSDecimalNumber decimalNumberWithObjcValue:objcValue active:NO operationMode:mode];
}
//objcValue为NSString或NSNumber类型
+ (NSDecimalNumber *)decimalNumberWithObjcValue:(id)objcValue active:(BOOL)active operationMode:(HOperationMode)mode {
    NSString *objcStringValue = [NSDecimalNumber unFormatter:objcValue];
    if ([self isOnlyNumericWithText:objcStringValue]) {
        return [NSDecimalNumber decimalNumberWithString:objcStringValue];
    }
    switch (mode) {
        case adding: {
            if (active) return [NSDecimalNumber decimalNumberWithString:@"0"];
            else return [NSDecimalNumber decimalNumberWithString:@"0"];
        }
            break;
        case subtracting: {
            if (active) return [NSDecimalNumber decimalNumberWithString:@"0"];
            else return [NSDecimalNumber decimalNumberWithString:@"0"];
        }
            break;
        case multiplying: {
            if (active) return [NSDecimalNumber decimalNumberWithString:@"1"];
            else return [NSDecimalNumber decimalNumberWithString:@"1"];
        }
            break;
        case dividing: {
            if (active) return [NSDecimalNumber decimalNumberWithString:@"0"];
            else return [NSDecimalNumber decimalNumberWithString:@"1"];
        }
            break;
            
        default:
            break;
    }
    return nil;
}
@end

@implementation HNumberFormatter

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
    
    NSDecimalNumber *decimalNumber = [NSDecimalNumber activeDecimalNumberWithObjcValue:numberObjc operationMode:other];
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

@end

@implementation NSNumber (HFormatter)
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
