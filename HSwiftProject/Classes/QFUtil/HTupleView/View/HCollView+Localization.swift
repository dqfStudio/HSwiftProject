//
//  HCollView+Localization.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 国际化与本地化扩展
///
/// 提供多语言支持、区域适配和RTL支持等功能
extension HCollView {
    
    /// 本地化管理器
    class LocalizationManager {
        
        // MARK: - 单例
        static let shared = LocalizationManager()
        
        // MARK: - 属性

        /// 当前语言
        private var currentLanguage: String = ""
        
        /// 支持的语言
        private let supportedLanguages: [String] = ["en", "zh-Hans", "zh-Hant", "ja", "ko", "fr", "de", "es", "ru"]
        
        /// 语言包
        private var localizedStrings: [String: [String: String]] = [:]
        
        // MARK: - 初始化
        
        /// 初始化
        private init() {
            loadLocalizedStrings()
            setCurrentLanguage()
        }
        
        // MARK: - 方法
        
        /// 加载本地化字符串
        private func loadLocalizedStrings() {
            for language in supportedLanguages {
                if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
                   let bundle = Bundle(path: path),
                   let strings = bundle.localizedInfoDictionary as? [String: String] {
                    localizedStrings[language] = strings
                }
            }
        }
        
        /// 设置当前语言
        private func setCurrentLanguage() {
            let preferredLanguage = Locale.preferredLanguages.first ?? "en"
            currentLanguage = getLanguageCode(from: preferredLanguage)
        }
        
        /// 从语言代码中获取语言
        /// - Parameter languageCode: 语言代码
        /// - Returns: 语言
        private func getLanguageCode(from languageCode: String) -> String {
            let components = languageCode.components(separatedBy: "-")
            let baseLanguage = components.first ?? "en"
            
            // 检查是否支持该语言
            if supportedLanguages.contains(languageCode) {
                return languageCode
            } else if supportedLanguages.contains(baseLanguage) {
                return baseLanguage
            } else {
                return "en"
            }
        }
        
        /// 获取本地化字符串
        /// - Parameters:
        ///   - key: 字符串键
        ///   - language: 语言
        /// - Returns: 本地化字符串
        func localizedString(forKey key: String, language: String? = nil) -> String {
            let targetLanguage = language ?? currentLanguage
            
            if let strings = localizedStrings[targetLanguage],
               let localizedString = strings[key] {
                return localizedString
            } else if let strings = localizedStrings["en"],
                      let localizedString = strings[key] {
                return localizedString
            } else {
                return key
            }
        }
        
        /// 切换语言
        /// - Parameter language: 语言
        func setLanguage(_ language: String) {
            if supportedLanguages.contains(language) {
                currentLanguage = language
                
                // 通知语言变化
                NotificationCenter.default.post(name: .HCollViewLanguageChanged, object: language)
            }
        }
        
        /// 获取当前语言
        /// - Returns: 当前语言
        func getCurrentLanguage() -> String {
            return currentLanguage
        }
        
        /// 获取支持的语言
        /// - Returns: 支持的语言
        func getSupportedLanguages() -> [String] {
            return supportedLanguages
        }
        
        /// 格式化日期
        /// - Parameters:
        ///   - date: 日期
        ///   - style: 日期样式
        /// - Returns: 格式化后的日期字符串
        func formatDate(_ date: Date, style: DateFormatter.Style = .medium) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = style
            formatter.locale = Locale(identifier: currentLanguage)
            return formatter.string(from: date)
        }
        
        /// 格式化时间
        /// - Parameters:
        ///   - date: 日期
        ///   - style: 时间样式
        /// - Returns: 格式化后的时间字符串
        func formatTime(_ date: Date, style: DateFormatter.Style = .medium) -> String {
            let formatter = DateFormatter()
            formatter.timeStyle = style
            formatter.locale = Locale(identifier: currentLanguage)
            return formatter.string(from: date)
        }
        
        /// 格式化数字
        /// - Parameters:
        ///   - number: 数字
        ///   - style: 数字样式
        /// - Returns: 格式化后的数字字符串
        func formatNumber(_ number: NSNumber, style: NumberFormatter.Style = .decimal) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = style
            formatter.locale = Locale(identifier: currentLanguage)
            return formatter.string(from: number) ?? ""
        }
        
        /// 格式化货币
        /// - Parameters:
        ///   - amount: 金额
        ///   - currencyCode: 货币代码
        /// - Returns: 格式化后的货币字符串
        func formatCurrency(_ amount: NSNumber, currencyCode: String = "USD") -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: currentLanguage)
            formatter.currencyCode = currencyCode
            return formatter.string(from: amount) ?? ""
        }
        
        /// 检查是否是RTL语言
        /// - Returns: 是否是RTL语言
        func isRTLLanguage() -> Bool {
            return Locale.characterDirection(forLanguage: currentLanguage) == .rightToLeft
        }
    }
    
    /// 本地化管理器
    var localizationManager: LocalizationManager {
        return LocalizationManager.shared
    }
    
    /// 获取本地化字符串
    /// - Parameters:
    ///   - key: 字符串键
    ///   - language: 语言
    /// - Returns: 本地化字符串
    func localizedString(forKey key: String, language: String? = nil) -> String {
        return localizationManager.localizedString(forKey: key, language: language)
    }
    
    /// 切换语言
    /// - Parameter language: 语言
    func setLanguage(_ language: String) {
        localizationManager.setLanguage(language)
    }
    
    /// 获取当前语言
    /// - Returns: 当前语言
    func getCurrentLanguage() -> String {
        return localizationManager.getCurrentLanguage()
    }
    
    /// 获取支持的语言
    /// - Returns: 支持的语言
    func getSupportedLanguages() -> [String] {
        return localizationManager.getSupportedLanguages()
    }
    
    /// 格式化日期
    /// - Parameters:
    ///   - date: 日期
    ///   - style: 日期样式
    /// - Returns: 格式化后的日期字符串
    func formatDate(_ date: Date, style: DateFormatter.Style = .medium) -> String {
        return localizationManager.formatDate(date, style: style)
    }
    
    /// 格式化时间
    /// - Parameters:
    ///   - date: 日期
    ///   - style: 时间样式
    /// - Returns: 格式化后的时间字符串
    func formatTime(_ date: Date, style: DateFormatter.Style = .medium) -> String {
        return localizationManager.formatTime(date, style: style)
    }
    
    /// 格式化数字
    /// - Parameters:
    ///   - number: 数字
    ///   - style: 数字样式
    /// - Returns: 格式化后的数字字符串
    func formatNumber(_ number: NSNumber, style: NumberFormatter.Style = .decimal) -> String {
        return localizationManager.formatNumber(number, style: style)
    }
    
    /// 格式化货币
    /// - Parameters:
    ///   - amount: 金额
    ///   - currencyCode: 货币代码
    /// - Returns: 格式化后的货币字符串
    func formatCurrency(_ amount: NSNumber, currencyCode: String = "USD") -> String {
        return localizationManager.formatCurrency(amount, currencyCode: currencyCode)
    }
    
    /// 检查是否是RTL语言
    /// - Returns: 是否是RTL语言
    func isRTLLanguage() -> Bool {
        return localizationManager.isRTLLanguage()
    }
    
    /// 注册语言变化通知
    func registerForLanguageChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(languageChanged),
            name: .HCollViewLanguageChanged,
            object: nil
        )
    }
    
    /// 取消注册语言变化通知
    func unregisterForLanguageChanges() {
        NotificationCenter.default.removeObserver(self, name: .HCollViewLanguageChanged, object: nil)
    }
    
    /// 语言变化回调
    @objc private func languageChanged(notification: Notification) {
        if let language = notification.object as? String {
            // 处理语言变化
            reloadData()
        }
    }
}

/// 通知名称扩展
extension Notification.Name {
    static let HCollViewLanguageChanged = Notification.Name("HCollViewLanguageChanged")
}
