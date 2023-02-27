//
//  HNumberFormatter.h
//  QFProj
//
//  Created by dqf on 2021/4/30.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HNumberFormatterRoundingMode) {
    roundCeiling = NSNumberFormatterRoundCeiling,
    roundFloor = NSNumberFormatterRoundFloor,
    roundDown = NSNumberFormatterRoundDown,
    roundUp = NSNumberFormatterRoundUp,
    roundHalfEven = NSNumberFormatterRoundHalfEven,
    roundHalfDown = NSNumberFormatterRoundHalfDown,
    roundHalfUp = NSNumberFormatterRoundHalfUp
};

NS_ASSUME_NONNULL_BEGIN

@interface HNumberFormatter : NSObject
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
@end

@interface NSNumber (HFormatter)
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
@end

@interface NSString (HFormatter)
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
@end

NS_ASSUME_NONNULL_END
