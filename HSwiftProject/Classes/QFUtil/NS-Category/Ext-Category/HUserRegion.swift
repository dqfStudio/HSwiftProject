//
//  HUserRegion.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/16.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var KRegionCodeKey = "KRegionCodeKey"
private var KLanguageCodeKey = "KLanguageCodeKey"

/*
 根据项目实际情况作出如下更改：
 1.将country概念改为region
 */

class HUserRegion: NSObject {
    
    static var defaultRegion: HUserRegion = {
        return HUserRegion()
    }()
    
    //区域代码
    private var _regionCode: String?
    var regionCode: String {
        get {
            // 1、如果有值直接返回
            if let regionCode = _regionCode {
                return regionCode
            }

            // 2、如果数据库里有值直接返回
            _regionCode = UserDefaults.standard.object(forKey: KRegionCodeKey) as? String
            if let regionCode = _regionCode {
                return regionCode
            }

            // 3、如果用户没有设置区域，读取“设置-通用-地区”中默认的区域
            _regionCode = NSLocale.autoupdatingCurrent.currencyCode

            // 4、如果用户没有设置区域，读取区域json文件中最后一项
            if let regionCode = _regionCode, let supportedRegions = self.supportedRegions, !(supportedRegions.allKeys as NSArray).contains(regionCode) {
                _regionCode = supportedRegions.allKeys.last as? String
            }

            // 5、保存新的值
            UserDefaults.standard.set(_regionCode, forKey: KRegionCodeKey)
            UserDefaults.standard.synchronize()

            return _regionCode!
        }
        
        set {
            // 1、如果没有新的直接返回
            guard _regionCode != newValue else {
                return
            }

            // 2、赋予新的值
            _regionCode = newValue

            // 3、如果有值直接返回
            if _regionCode == nil {
                // 4、如果用户没有设置区域，读取“设置-通用-地区”中默认的区域
                _regionCode = NSLocale.autoupdatingCurrent.currencyCode
            }

            // 5、如果用户没有设置区域，读取区域json文件中最后一项
            if let regionCode = _regionCode, let supportedRegions = self.supportedRegions, !(supportedRegions.allKeys as NSArray).contains(regionCode) {
                _regionCode = supportedRegions.allKeys.last as? String
            }

            // 6、保存新的值
            UserDefaults.standard.set(_regionCode, forKey: KRegionCodeKey)
            UserDefaults.standard.synchronize()

        }
    }
    
    //区域名称
    var regionName: String? {
        if let regionLocalDict = self.regionLocalDict,
           let regionDict = regionLocalDict.object(forKey: self.regionCode) as? NSDictionary,
           let name = regionDict["regionName"] as? String {
            return name
        }
        return nil
    }
    
    //支持的区域列表
    var supportedRegions: NSDictionary? {
        guard let path = Bundle.main.path(forResource: "HSupportedRegions", ofType: "json"),
              let data = NSData(contentsOfFile: path) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary
    }
    
    //获取不同的语言文件内容
    private var regionLocalDict: NSDictionary? {
        guard let path = Bundle.main.path(forResource: self.languageCode, ofType: "lproj"),
              let currentBundle = Bundle(path: path),
              let data = NSData(contentsOfFile: currentBundle.path(forResource: "HRegionLocal", ofType: "json") ?? "") else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary
    }
    
    
    //语言代码
    private var _languageCode: String?
    var languageCode: String {
        get {
            // 1、如果有值直接返回
            if let languageCode = _languageCode {
                return languageCode
            }

            // 2、如果数据库里有值直接返回
            _languageCode = UserDefaults.standard.object(forKey: KLanguageCodeKey) as? String
            if let languageCode = _languageCode {
                return languageCode
            }

            // 3、如果用户没有设置语言，读取“设置-通用-语言”中默认的语言
            _languageCode = NSLocale.preferredLanguages.first

            // 4、如果用户没有设置语言，读取语言json文件中最后一项
            if let languageCode = _languageCode, let supportedLanguages = self.supportedLanguages, !(supportedLanguages.allKeys as NSArray).contains(languageCode) {
                _languageCode = supportedLanguages.allKeys.last as? String
            }

            // 5、保存新的值
            UserDefaults.standard.set(_languageCode, forKey: KLanguageCodeKey)
            UserDefaults.standard.synchronize()

            return _languageCode!
        }
        
        set {
            // 1、如果没有新的直接返回
            guard _languageCode != newValue else {
                return
            }

            // 2、赋予新的值
            _languageCode = newValue

            // 3、如果有值直接返回
            if _languageCode == nil {
                // 3、如果用户没有设置语言，读取“设置-通用-语言”中默认的语言
                _languageCode = NSLocale.preferredLanguages.first
            }

            // 5、如果用户没有设置语言，读取语言json文件中最后一项
            if let languageCode = _languageCode, let supportedLanguages = self.supportedLanguages, !(supportedLanguages.allKeys as NSArray).contains(languageCode) {
                _languageCode = supportedLanguages.allKeys.last as? String
            }

            // 6、保存新的值
            UserDefaults.standard.set(_languageCode, forKey: KLanguageCodeKey)
            UserDefaults.standard.synchronize()

        }
    }

    //语言名称
    var languageName: String? {
        if let supportedLanguages = self.supportedLanguages,
           let languages = supportedLanguages[self.languageCode] as? [String: Any],
           let name = languages["languageName"] as? String {
            return name
        }
        return nil
    }
    
    //支持的语言列表
    var supportedLanguages: NSDictionary? {
        guard let path = Bundle.main.path(forResource: "HSupportedLanguages", ofType: "json"),
              let data = NSData(contentsOfFile: path) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary
    }
    
    //货币符号
    var currencySymbol: String? {
        if let supportedRegions = self.supportedRegions,
           let regions = supportedRegions[self.regionCode] as? [String: Any],
           let symbol = regions["currencySymbol"] as? String {
            return symbol
        }
        return nil
    }
    
    func currencySymbolWithFactors(_ factors: String) -> String? {
        guard let supportedRegions = self.supportedRegions, factors.count > 0 else { return nil }
        for tmpDict in supportedRegions.allValues {
            guard let dict = tmpDict as? NSDictionary,
                  let currencySymbol = dict["currencySymbol"] as? String,
                  (dict.allValues as NSArray).contains(factors) else { continue }
            return currencySymbol
        }
        return nil
    }
    
    //货币代码
    var currencyCode: String? {
        if let supportedRegions = self.supportedRegions,
           let regions = supportedRegions[self.regionCode] as? [String: Any],
           let code = regions["currencyCode"] as? String {
            return code
        }
        return nil
    }
    
    func currencyCodeWithFactors(_ factors: String) -> String? {
        guard let supportedRegions = self.supportedRegions, factors.count > 0 else { return nil }
        for tmpDict in supportedRegions.allValues {
            guard let dict = tmpDict as? NSDictionary,
                  let currencyCode = dict["currencyCode"] as? String,
                  (dict.allValues as NSArray).contains(factors) else { continue }
            return currencyCode
        }
        return nil
    }
    
    //货币图标
    var currencyIcon: UIImage? {
        if let supportedRegions = self.supportedRegions,
           let dict = supportedRegions.object(forKey: self.regionCode) as? NSDictionary,
           let currencyIconName = dict["currencyIconName"] as? String,
           let image = UIImage(named: currencyIconName) {
            return image
        }
        return nil
    }
    
    func currencyIconWithFactors(_ factors: String) -> UIImage? {
        guard let supportedRegions = self.supportedRegions, factors.count > 0 else { return nil }
        for tmpDict in supportedRegions.allValues {
            guard let dict = tmpDict as? NSDictionary,
                  let currencyIconName = dict["currencyIconName"] as? String,
                  (dict.allValues as NSArray).contains(factors) else { continue }
            return UIImage(named: currencyIconName)
        }
        return nil
    }
    
    //分组分隔符
    var groupingSeparator: String? {
        if let supportedRegions = self.supportedRegions,
           let dict = supportedRegions.object(forKey: self.regionCode) as? NSDictionary,
           let separator = dict["groupingSeparator"] as? String {
            return separator
        }
        return nil
    }
    
    //小数分隔符
    var decimalSeparator: String? {
        if let supportedRegions = self.supportedRegions,
           let dict = supportedRegions.object(forKey: self.regionCode) as? NSDictionary,
           let separator = dict["decimalSeparator"] as? String {
            return separator
        }
        return nil
    }
    
    //获取地区代码序号
    var sceneRegionCodeIndex: Int {
        guard let supportedRegions = self.supportedRegions else { return NSNotFound }
        return (supportedRegions.allKeys as NSArray).index(of: self.regionCode)
    }
    
    //获取语言代码的序号
    var sceneLanguageCodeIndex: Int {
        guard let supportedLanguages = self.supportedLanguages else { return NSNotFound }
        return (supportedLanguages.allKeys as NSArray).index(of: self.languageCode)
    }
    
}
