//
//  HUserRegion.h
//  QFProj
//
//  Created by Wind on 2021/5/13.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 根据项目实际情况作出如下更改：
 1.将country概念改为region
 */

@interface HUserRegion : NSObject

+ (HUserRegion *)defaultRegion;

//APP中可设置某个地区名称
@property (nonatomic) NSString *regionCode;//区域名称
@property (nonatomic, readonly) NSString *regionName;//区域代码
@property (nonatomic, readonly) NSDictionary *supportedRegions;//支持的区域列表

//APP中可设置某个地区语言代码
@property (nonatomic) NSString *languageCode;//语言代码
@property (nonatomic, readonly) NSString *languageName;//语言名称
@property (nonatomic, readonly) NSDictionary *supportedLanguages;//支持的语言列表

@property (nonatomic, readonly) NSString *currencyCode;//货币代码
- (NSString *)currencyCodeWithFactors:(NSString *)factors;

@property (nonatomic, readonly) NSString *currencySymbol;//货币符号
- (NSString *)currencySymbolWithFactors:(NSString *)factors;

@property (nonatomic, readonly) UIImage  *currencyIcon;//货币图标
- (UIImage *)currencyIconWithFactors:(NSString *)factors;

@property (nonatomic, readonly) NSString *groupingSeparator;//分组分隔符
@property (nonatomic, readonly) NSString *decimalSeparator;//小数分隔符

//获取地区代码序号
- (NSInteger)sceneRegionCodeIndex;
//获取语言代码的序号
- (NSInteger)sceneLanguageCodeIndex;

@end

NS_ASSUME_NONNULL_END
