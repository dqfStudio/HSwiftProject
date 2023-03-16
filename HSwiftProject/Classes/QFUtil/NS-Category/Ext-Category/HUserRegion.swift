//
//  HUserRegion.swift
//  HSwiftProject
//
//  Created by owner on 2023/3/16.
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
            if _regionCode == nil {
                _regionCode = UserDefaults.standard.object(forKey: KRegionCodeKey) as? String
                if _regionCode == nil {
                    //如果用户没有设置区域，读取“设置-通用-地区”中默认的区域
                    _regionCode = NSLocale.autoupdatingCurrent.currencyCode
                    if !(self.supportedRegions.allKeys as NSArray).contains(_regionCode!) {
                        //如果用户没有设置区域，读取区域json文件中最后一项
                        _regionCode = self.supportedRegions.allKeys.last as? String
                    }
                    UserDefaults.standard.set(_regionCode, forKey: KRegionCodeKey)
                    UserDefaults.standard.synchronize()
                }
            }
            return _regionCode!
        }
        set {
            if _regionCode != newValue {
                _regionCode = nil
                _regionCode = newValue
                if _regionCode == nil || !(self.supportedRegions.allKeys as NSArray).contains(_regionCode!) {
                    //如果用户没有设置区域，读取“设置-通用-地区”中默认的区域
                    _regionCode = NSLocale.autoupdatingCurrent.currencyCode
                    if !(self.supportedRegions.allKeys as NSArray).contains(_regionCode!) {
                        //如果用户没有设置区域，读取区域json文件中最后一项
                        _regionCode = self.supportedRegions.allKeys.last as? String
                    }
                }
                UserDefaults.standard.set(_regionCode, forKey: KRegionCodeKey)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    //区域名称
    var regionName: String {
        return (self.regionLocalDict.object(forKey: self.regionCode) as! NSDictionary)["regionNameregionName"] as! String
    }
    
    //支持的区域列表
    var supportedRegions: NSDictionary {
        let path = Bundle.main.path(forResource: "HSupportedRegions", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        return try! JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! NSDictionary
    }
    
    //获取不同的语言文件内容
    private var regionLocalDict: NSDictionary {
        var path = Bundle.main.path(forResource: self.languageCode, ofType: "lproj")
        let currentBundle = Bundle(path: path!)
        path = currentBundle!.path(forResource: "HRegionLocal", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        return try! JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! NSDictionary
    }
    
    
    //语言代码
    private var _languageCode: String?
    var languageCode: String {
        get {
            if _languageCode == nil {
                _languageCode = UserDefaults.standard.object(forKey: KLanguageCodeKey) as? String
                if _languageCode == nil {
                    //如果用户没有设置语言，读取“设置-通用-语言”中默认的语言
                    _languageCode = NSLocale.preferredLanguages.first
                    if !(self.supportedLanguages.allKeys as NSArray).contains(_languageCode!) {
                        //如果用户没有设置语言，读取语言json文件中最后一项
                        _languageCode = self.supportedLanguages.allKeys.last as? String
                    }
                }
                UserDefaults.standard.set(_languageCode!, forKey: KLanguageCodeKey)
                UserDefaults.standard.synchronize()
            }
            return _languageCode!
        }
        set {
            if _languageCode != newValue {
                _languageCode = nil
                _languageCode = languageCode
                if _languageCode == nil || !(self.supportedLanguages.allKeys as NSArray).contains(_languageCode!) {
                    //如果用户没有设置语言，读取“设置-通用-语言”中默认的语言
                    _languageCode = NSLocale.preferredLanguages.first
                    
                    if !(self.supportedLanguages.allKeys as NSArray).contains(_languageCode!) {
                        //如果用户没有设置语言，读取语言json文件中最后一项
                        _languageCode = self.supportedLanguages.allKeys.last as? String
                    }
                }
                UserDefaults.standard.set(_languageCode, forKey: KLanguageCodeKey)
                UserDefaults.standard.synchronize()
            }
        }
    }

    //语言名称
    var languageName: String {
        return (self.supportedLanguages.object(forKey: self.languageCode) as! NSDictionary)["languageName"] as! String
    }
    
    //支持的语言列表
    var supportedLanguages: NSDictionary {
        let path = Bundle.main.path(forResource: "HSupportedLanguages", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        return try! JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! NSDictionary
    }
    
    //货币符号
    var currencySymbol: String {
        return (self.supportedRegions.object(forKey: self.regionCode) as! NSDictionary)["currencySymbol"] as! String
    }
    
    func currencySymbolWithFactors(_ factors: String) -> String {
        if factors.length > 0 {
            for tmpDict in self.supportedRegions.allValues {
                let dict = tmpDict as! NSDictionary
                if (dict.allValues as NSArray).contains(factors) {
                    return dict["currencySymbol"] as! String
                }
            }
        }
        return ""
    }
    
    //货币代码
    var currencyCode: String {
        return (self.supportedRegions.object(forKey: self.regionCode) as! NSDictionary)["currencyCode"] as! String
    }
    
    func currencyCodeWithFactors(_ factors: String) -> String {
        if factors.length > 0 {
            for tmpDict in self.supportedRegions.allValues {
                let dict = tmpDict as! NSDictionary
                if (dict.allValues as NSArray).contains(factors) {
                    return dict["currencyCode"] as! String
                }
            }
        }
        return ""
    }
    
    //货币图标
    var currencyIcon: UIImage {
        let dict = self.supportedRegions.object(forKey: self.regionCode) as! NSDictionary
        return UIImage(named: dict["currencyIconName"] as! String)!
    }
    
    func currencyIconWithFactors(_ factors: String) -> UIImage? {
        if factors.length > 0 {
            for tmpDict in self.supportedRegions.allValues {
                let dict = tmpDict as! NSDictionary
                if (dict.allValues as NSArray).contains(factors) {
                    return UIImage(named: dict["currencyIconName"] as! String)
                }
            }
        }
        return nil
    }
    
    //分组分隔符
    var groupingSeparator: String {
        return (self.supportedRegions.object(forKey: self.regionCode) as! NSDictionary)["groupingSeparator"] as! String
    }
    //小数分隔符
    var decimalSeparator: String {
        return (self.supportedRegions.object(forKey: self.regionCode) as! NSDictionary)["decimalSeparator"] as! String
    }
    
    //获取地区代码序号
    var sceneRegionCodeIndex: Int {
        return (self.supportedRegions.allKeys as NSArray).index(of: self.regionCode)
    }
    
    //获取语言代码的序号
    var sceneLanguageCodeIndex: Int {
        return (self.supportedLanguages.allKeys as NSArray).index(of: self.languageCode)
    }
    
}
