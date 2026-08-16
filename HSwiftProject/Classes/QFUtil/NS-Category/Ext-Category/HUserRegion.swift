//
//  HUserRegion.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/16.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var kRegionCodeKey = "kRegionCodeKey"
private var kLanguageCodeKey = "kLanguageCodeKey"

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
            if let regionCode = _regionCode {
                return regionCode
            }
            let stored = UserDefaults.standard.string(forKey: kRegionCodeKey)
            let resolved = fallbackRegionCode(stored)
            persistRegion(resolved, previous: stored)
            return resolved
        }
        
        set {
            let resolved = fallbackRegionCode(newValue)
            guard _regionCode != resolved else { return }
            persistRegion(resolved, previous: UserDefaults.standard.string(forKey: kRegionCodeKey))
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
    
    private var _supportedRegions: NSDictionary?
    var supportedRegions: NSDictionary? {
        if let cached = _supportedRegions { return cached }
        guard let path = Bundle.main.path(forResource: "HSupportedRegions", ofType: "json"),
              let data = NSData(contentsOfFile: path) else {
            return nil
        }
        _supportedRegions = try? JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary
        return _supportedRegions
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
            if let languageCode = _languageCode {
                return languageCode
            }
            let stored = UserDefaults.standard.string(forKey: kLanguageCodeKey)
            let resolved = fallbackLanguageCode(stored)
            persistLanguage(resolved, previous: stored)
            return resolved
        }
        
        set {
            let resolved = fallbackLanguageCode(newValue)
            guard _languageCode != resolved else { return }
            persistLanguage(resolved, previous: UserDefaults.standard.string(forKey: kLanguageCodeKey))
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
    
    private var _supportedLanguages: NSDictionary?
    var supportedLanguages: NSDictionary? {
        if let cached = _supportedLanguages { return cached }
        guard let path = Bundle.main.path(forResource: "HSupportedLanguages", ofType: "json"),
              let data = NSData(contentsOfFile: path) else {
            return nil
        }
        _supportedLanguages = try? JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary
        return _supportedLanguages
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

    private func persistRegion(_ code: String, previous: String?) {
        _regionCode = code
        if previous != code {
            UserDefaults.standard.set(code, forKey: kRegionCodeKey)
        }
    }

    private func persistLanguage(_ code: String, previous: String?) {
        _languageCode = code
        if previous != code {
            UserDefaults.standard.set(code, forKey: kLanguageCodeKey)
        }
    }

    private func currentRegionIdentifier() -> String? {
        if #available(iOS 16.0, *) {
            return Locale.autoupdatingCurrent.region?.identifier
        }
        return Locale.autoupdatingCurrent.regionCode
    }

    private func firstSupportedKey(_ dict: NSDictionary?) -> String? {
        dict?.allKeys.compactMap { $0 as? String }.sorted().first
    }

    private func fallbackRegionCode(_ candidate: String?) -> String {
        let supported = supportedRegions
        if let candidate, supported?.object(forKey: candidate) != nil {
            return candidate
        }
        if let current = currentRegionIdentifier() {
            if supported == nil || supported?.object(forKey: current) != nil {
                return current
            }
        }
        return firstSupportedKey(supported) ?? candidate ?? "CN"
    }

    private func fallbackLanguageCode(_ candidate: String?) -> String {
        let preferred = candidate ?? Locale.preferredLanguages.first ?? "en"
        guard let supported = supportedLanguages, supported.count > 0 else {
            return preferred
        }
        if let matched = matchLanguage(preferred, keys: supported.allKeys) {
            return matched
        }
        return firstSupportedKey(supported) ?? preferred
    }

    private func matchLanguage(_ preferred: String, keys: [Any]) -> String? {
        let stringKeys = keys.compactMap { $0 as? String }
        if stringKeys.contains(preferred) { return preferred }
        var parts = preferred.split(separator: "-").map(String.init)
        while parts.count > 1 {
            parts.removeLast()
            let candidate = parts.joined(separator: "-")
            if stringKeys.contains(candidate) { return candidate }
        }
        return nil
    }
    
}
