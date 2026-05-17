//
//  HCollView+Extensibility.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 扩展性扩展
///
/// 提供统一的插件系统、主题系统和国际化支持等功能
extension HCollView {
    
    /// 扩展性管理器
    class ExtensibilityManager {
        
        // MARK: - 单例
        static let shared = ExtensibilityManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 插件列表
        private var plugins: [String: HCollViewExtPlugin] = [:]
        
        /// 主题
        private var currentTheme: HCollViewExtTheme = ExtDefaultTheme()
        
        /// 语言
        private var currentLanguage: String = "zh-CN"
        
        /// 国际化字符串
        private var localizedStrings: [String: [String: String]] = [
            "zh-CN": [
                "loading": "加载中...",
                "empty": "暂无数据",
                "error": "加载失败",
                "retry": "重试",
                "cancel": "取消",
                "confirm": "确认"
            ],
            "en-US": [
                "loading": "Loading...",
                "empty": "No data",
                "error": "Load failed",
                "retry": "Retry",
                "cancel": "Cancel",
                "confirm": "Confirm"
            ]
        ]
        
        // MARK: - 方法
        
        /// 注册插件
        /// - Parameters:
        ///   - plugin: 插件
        ///   - key: 插件键
        func registerExtPlugin(_ plugin: HCollViewExtPlugin, forKey key: String) {
            plugins[key] = plugin
            plugin.setup(self)
        }
        
        /// 移除插件
        /// - Parameter key: 插件键
        func removeExtPlugin(forKey key: String) {
            if let plugin = plugins[key] {
                plugin.teardown()
                plugins.removeValue(forKey: key)
            }
        }
        
        /// 获取插件
        /// - Parameter key: 插件键
        /// - Returns: 插件
        func getExtPlugin(forKey key: String) -> HCollViewExtPlugin? {
            return plugins[key]
        }
        
        /// 调用所有插件的方法
        /// - Parameters:
        ///   - method: 方法名
        ///   - parameters: 参数
        func callExtPlugins(method: String, parameters: [Any] = []) {
            for plugin in plugins.values {
                plugin.callMethod(method, parameters: parameters)
            }
        }
        
        /// 设置主题
        /// - Parameter theme: 主题
        func setExtTheme(_ theme: HCollViewExtTheme) {
            currentTheme = theme
        }
        
        /// 获取当前主题
        /// - Returns: 当前主题
        func getCurrentExtTheme() -> HCollViewExtTheme {
            return currentTheme
        }
        
        /// 设置语言
        /// - Parameter language: 语言代码
        func setExtLanguage(_ language: String) {
            currentLanguage = language
        }
        
        /// 获取当前语言
        /// - Returns: 当前语言代码
        func getCurrentExtLanguage() -> String {
            return currentLanguage
        }
        
        /// 添加国际化字符串
        /// - Parameters:
        ///   - strings: 字符串字典
        ///   - language: 语言代码
        func addLocalizedStrings(_ strings: [String: String], forLanguage language: String) {
            if localizedStrings[language] == nil {
                localizedStrings[language] = [:]
            }
            localizedStrings[language]?.merge(strings) { _, new in new }
        }
        
        /// 获取国际化字符串
        /// - Parameters:
        ///   - key: 字符串键
        ///   - language: 语言代码（默认使用当前语言）
        /// - Returns: 国际化字符串
        func getLocalizedString(_ key: String, forLanguage language: String? = nil) -> String {
            let lang = language ?? currentLanguage
            if let strings = localizedStrings[lang], let value = strings[key] {
                return value
            }
            return key
        }
        
        /// 清理插件
        func clearExtPlugins() {
            for plugin in plugins.values {
                plugin.teardown()
            }
            plugins.removeAll()
        }
    }
    
    /// 扩展性管理器
    var extensibilityManager: ExtensibilityManager {
        return ExtensibilityManager.shared
    }
    
    /// 注册插件
    /// - Parameters:
    ///   - plugin: 插件
    ///   - key: 插件键
    func registerExtPlugin(_ plugin: HCollViewExtPlugin, forKey key: String) {
        extensibilityManager.registerExtPlugin(plugin, forKey: key)
    }
    
    /// 移除插件
    /// - Parameter key: 插件键
    func removeExtPlugin(forKey key: String) {
        extensibilityManager.removeExtPlugin(forKey: key)
    }
    
    /// 获取插件
    /// - Parameter key: 插件键
    /// - Returns: 插件
    func getExtPlugin(forKey key: String) -> HCollViewExtPlugin? {
        return extensibilityManager.getExtPlugin(forKey: key)
    }
    
    /// 调用所有插件的方法
    /// - Parameters:
    ///   - method: 方法名
    ///   - parameters: 参数
    func callExtPlugins(method: String, parameters: [Any] = []) {
        extensibilityManager.callExtPlugins(method: method, parameters: parameters)
    }
    
    /// 设置扩展主题
    /// - Parameter theme: 主题
    func setExtTheme(_ theme: HCollViewExtTheme) {
        extensibilityManager.setExtTheme(theme)
        applyExtTheme()
    }
    
    /// 获取当前扩展主题
    /// - Returns: 当前主题
    func getCurrentExtTheme() -> HCollViewExtTheme {
        return extensibilityManager.getCurrentExtTheme()
    }
    
    /// 设置扩展语言
    /// - Parameter language: 语言代码
    func setExtLanguage(_ language: String) {
        extensibilityManager.setExtLanguage(language)
    }
    
    /// 获取当前扩展语言
    /// - Returns: 当前语言代码
    func getCurrentExtLanguage() -> String {
        return extensibilityManager.getCurrentExtLanguage()
    }
    
    /// 添加国际化字符串
    /// - Parameters:
    ///   - strings: 字符串字典
    ///   - language: 语言代码
    func addLocalizedStrings(_ strings: [String: String], forLanguage language: String) {
        extensibilityManager.addLocalizedStrings(strings, forLanguage: language)
    }
    
    /// 获取国际化字符串
    /// - Parameters:
    ///   - key: 字符串键
    ///   - language: 语言代码（默认使用当前语言）
    /// - Returns: 国际化字符串
    func getLocalizedString(_ key: String, forLanguage language: String? = nil) -> String {
        return extensibilityManager.getLocalizedString(key, forLanguage: language)
    }
    
    /// 应用扩展主题
    private func applyExtTheme() {
        let theme = getCurrentExtTheme()
        
        // 应用主题到集合视图
        backgroundColor = theme.extBackgroundColor
        tintColor = theme.extTintColor
        
        // 应用主题到单元格
        // 这里需要根据实际情况实现
    }
    
    /// 清理扩展插件
    func clearExtPlugins() {
        extensibilityManager.clearExtPlugins()
    }
}

/// HCollView 扩展插件协议
protocol HCollViewExtPlugin {
    
    /// 初始化
    init()
    
    /// 设置
    /// - Parameter manager: 扩展性管理器
    func setup(_ manager: HCollView.ExtensibilityManager)
    
    /// 拆卸
    func teardown()
    
    /// 调用方法
    /// - Parameters:
    ///   - method: 方法名
    ///   - parameters: 参数
    func callMethod(_ method: String, parameters: [Any])
}

/// HCollView 扩展主题协议
protocol HCollViewExtTheme {
    
    /// 背景颜色
    var extBackgroundColor: UIColor { get }
    
    /// 主题色
    var extTintColor: UIColor { get }
    
    /// 文本颜色
    var extTextColor: UIColor { get }
    
    /// 副标题颜色
    var extSecondaryTextColor: UIColor { get }
    
    /// 边框颜色
    var extBorderColor: UIColor { get }
    
    /// 边框宽度
    var extBorderWidth: CGFloat { get }
    
    /// 圆角半径
    var extCornerRadius: CGFloat { get }
    
    /// 阴影颜色
    var extShadowColor: UIColor { get }
    
    /// 阴影偏移
    var extShadowOffset: CGSize { get }
    
    /// 阴影半径
    var extShadowRadius: CGFloat { get }
    
    /// 阴影不透明度
    var extShadowOpacity: Float { get }
}

/// 默认扩展主题
class ExtDefaultTheme: HCollViewExtTheme {
    
    var extBackgroundColor: UIColor { return .white }
    var extTintColor: UIColor { return .blue }
    var extTextColor: UIColor { return .black }
    var extSecondaryTextColor: UIColor { return .gray }
    var extBorderColor: UIColor { return .lightGray }
    var extBorderWidth: CGFloat { return 1.0 }
    var extCornerRadius: CGFloat { return 8.0 }
    var extShadowColor: UIColor { return .black }
    var extShadowOffset: CGSize { return CGSize(width: 0, height: 2) }
    var extShadowRadius: CGFloat { return 4.0 }
    var extShadowOpacity: Float { return 0.2 }
}

/// 暗黑扩展主题
class ExtDarkTheme: HCollViewExtTheme {
    
    var extBackgroundColor: UIColor { return .black }
    var extTintColor: UIColor { return .blue }
    var extTextColor: UIColor { return .white }
    var extSecondaryTextColor: UIColor { return .lightGray }
    var extBorderColor: UIColor { return .darkGray }
    var extBorderWidth: CGFloat { return 1.0 }
    var extCornerRadius: CGFloat { return 8.0 }
    var extShadowColor: UIColor { return .white }
    var extShadowOffset: CGSize { return CGSize(width: 0, height: 2) }
    var extShadowRadius: CGFloat { return 4.0 }
    var extShadowOpacity: Float { return 0.1 }
}

/// 示例扩展插件
class ExtExamplePlugin: HCollViewExtPlugin {
    
    required init() {}
    
    func setup(_ manager: HCollView.ExtensibilityManager) {
        print("ExtExamplePlugin setup")
    }
    
    func teardown() {
        print("ExtExamplePlugin teardown")
    }
    
    func callMethod(_ method: String, parameters: [Any]) {
        print("ExtExamplePlugin callMethod: \(method), parameters: \(parameters)")
    }
}
