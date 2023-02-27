//
//  HUserRegion.m
//  QFProj
//
//  Created by Wind on 2021/5/13.
//  Copyright © 2021 dqfStudio. All rights reserved.
//

#import "HUserRegion.h"

#define KRegionCodeKey    @"KRegionCodeKey"
#define KLanguageCodeKey  @"KLanguageCodeKey"

@interface HUserRegion () {
    NSString *_regionCode;
    NSString *_languageCode;
}
@property (nonatomic) NSDictionary *regionLocalDict;
@end

@implementation HUserRegion

+ (HUserRegion *)defaultRegion {
    static HUserRegion *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

//区域代码
- (NSString *)regionCode {
    if (!_regionCode) {
        _regionCode = [[NSUserDefaults standardUserDefaults] objectForKey:KRegionCodeKey];
        if (!_regionCode) {
            //如果用户没有设置区域，读取“设置-通用-地区”中默认的区域
            _regionCode = [NSLocale autoupdatingCurrentLocale].countryCode;
            if (![self.supportedRegions.allKeys containsObject:_regionCode]) {
                //如果用户没有设置区域，读取区域json文件中最后一项
                _regionCode = self.supportedRegions.allKeys.lastObject;
            }
            [[NSUserDefaults standardUserDefaults] setObject:_regionCode forKey:KRegionCodeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return _regionCode;
}
- (void)setRegionCode:(NSString *)regionCode {
    if (_regionCode != regionCode) {
        _regionCode = nil;
        _regionCode = regionCode;
        if (!_regionCode || ![self.supportedRegions.allKeys containsObject:_regionCode]) {
            //如果用户没有设置区域，读取“设置-通用-地区”中默认的区域
            _regionCode = [NSLocale autoupdatingCurrentLocale].countryCode;
            if (![self.supportedRegions.allKeys containsObject:_regionCode]) {
                //如果用户没有设置区域，读取区域json文件中最后一项
                _regionCode = self.supportedRegions.allKeys.lastObject;
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:regionCode forKey:KRegionCodeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
//区域名称
- (NSString *)regionName {
    return self.regionLocalDict[self.regionCode][@"regionName"];
}
//支持的区域列表
- (NSDictionary *)supportedRegions {
    static dispatch_once_t once;
    static NSDictionary *dictionary;
    dispatch_once(&once, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HSupportedRegions" ofType:@"json"];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data) {
                id resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([resource isKindOfClass:NSDictionary.class]) {
                    dictionary = resource;
                }
            }
        }
    });
    return dictionary;
}
//获取不同的语言文件内容
- (NSDictionary *)regionLocalDict {
    if (!_regionLocalDict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.languageCode ofType:@"lproj"];
        NSBundle *currentBundle = [NSBundle bundleWithPath:path];
        path = [currentBundle pathForResource:@"HRegionLocal" ofType:@"json"];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data) {
                id resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([resource isKindOfClass:NSDictionary.class]) {
                    _regionLocalDict = resource;
                }
            }
        }
    }
    return _regionLocalDict;
}


//语言代码
- (NSString *)languageCode {
    if (!_languageCode) {
        _languageCode = [[NSUserDefaults standardUserDefaults] objectForKey:KLanguageCodeKey];
        if (!_languageCode) {
            //如果用户没有设置语言，读取“设置-通用-语言”中默认的语言
            _languageCode = [NSLocale preferredLanguages].firstObject;
            if (![self.supportedLanguages.allKeys containsObject:_languageCode]) {
                //如果用户没有设置语言，读取语言json文件中最后一项
                _languageCode = self.supportedLanguages.allKeys.lastObject;
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:_languageCode forKey:KLanguageCodeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return _languageCode;
}
- (void)setLanguageCode:(NSString *)languageCode {
    if (_languageCode != languageCode) {
        _languageCode = nil;
        _languageCode = languageCode;
        if (!_languageCode || ![self.supportedLanguages.allKeys containsObject:_languageCode]) {
            //如果用户没有设置语言，读取“设置-通用-语言”中默认的语言
            _languageCode = [NSLocale preferredLanguages].firstObject;
            if (![self.supportedLanguages.allKeys containsObject:_languageCode]) {
                //如果用户没有设置语言，读取语言json文件中最后一项
                _languageCode = self.supportedLanguages.allKeys.lastObject;
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:_languageCode forKey:KLanguageCodeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //将regionLocalDict置空，根据设置的语言重新获取
        _regionLocalDict = nil;
    }
}
//语言名称
- (NSString *)languageName {
    return self.supportedLanguages[self.languageCode][@"languageName"];
}
//支持的语言列表
- (NSDictionary *)supportedLanguages {
    static dispatch_once_t once;
    static NSDictionary *dictionary;
    dispatch_once(&once, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HSupportedLanguages" ofType:@"json"];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data) {
                id resource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([resource isKindOfClass:NSDictionary.class]) {
                    dictionary = resource;
                }
            }
        }
    });
    return dictionary;
}

//货币符号
- (NSString *)currencySymbol {
    return [self.supportedRegions objectForKey:self.regionCode][@"currencySymbol"];
}
//货币代码
- (NSString *)currencyCode {
    return [self.supportedRegions objectForKey:self.regionCode][@"currencyCode"];
}

//货币图标
- (UIImage *)currencyIcon {
    NSDictionary *dict = [self.supportedRegions objectForKey:self.regionCode];
    return [UIImage imageNamed:dict[@"currencyIconName"]];
}

//分组分隔符
- (NSString *)groupingSeparator {
    return [self.supportedRegions objectForKey:self.regionCode][@"groupingSeparator"];
}
//小数分隔符
- (NSString *)decimalSeparator {
    return [self.supportedRegions objectForKey:self.regionCode][@"decimalSeparator"];
}


- (UIImage *)currencyIconWithFactors:(NSString *)factors {
    if (factors.length > 0) {
        for (NSDictionary *dict in self.supportedRegions.allValues) {
            if ([dict.allValues containsObject:factors]) {
                return [UIImage imageNamed:dict[@"currencyIconName"]];
            }
        }
    }
    return nil;
}
- (NSString *)currencySymbolWithFactors:(NSString *)factors {
    if (factors.length > 0) {
        for (NSDictionary *dict in self.supportedRegions.allValues) {
            if ([dict.allValues containsObject:factors]) {
                return dict[@"currencySymbol"];
            }
        }
    }
    return @"";
}
- (NSString *)currencyCodeWithFactors:(NSString *)factors {
    if (factors.length > 0) {
        for (NSDictionary *dict in self.supportedRegions.allValues) {
            if ([dict.allValues containsObject:factors]) {
                return dict[@"currencyCode"];
            }
        }
    }
    return @"";
}



//获取地区代码序号
- (NSInteger)sceneRegionCodeIndex {
    return [self.supportedRegions.allKeys indexOfObject:self.regionCode];
}
//获取语言代码的序号
- (NSInteger)sceneLanguageCodeIndex {
    return [self.supportedLanguages.allKeys indexOfObject:self.languageCode];
}

@end
