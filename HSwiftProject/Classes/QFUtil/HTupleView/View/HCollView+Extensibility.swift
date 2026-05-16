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
/// 提供插件系统、主题系统和国际化支持等功能
extension HCollView {
    
    /// 扩展性管理器
    class ExtensibilityManager {
        
        // MARK: - 单例
        static let shared = ExtensibilityManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 插件列表
        private var plugins: [String: HCollViewPlugin] = [:]
        
        /// 主题
        private var currentTheme: HCollViewTheme = DefaultTheme()
        
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
        func registerPlugin(_ plugin: HCollViewPlugin, forKey key: String) {
            plugins[key] = plugin
            plugin.setup(self)
        }
        
        /// 移除插件
        /// - Parameter key: 插件键
        func removePlugin(forKey key: String) {
            if let plugin = plugins[key] {
                plugin.teardown()
                plugins.removeValue(forKey: key)
            }
        }
        
        /// 获取插件
        /// - Parameter key: 插件键
        /// - Returns: 插件
        func getPlugin(forKey key: String) -> HCollViewPlugin? {
            return plugins[key]
        }
        
        /// 调用所有插件的方法
        /// - Parameters:
        ///   - method: 方法名
        ///   - parameters: 参数
        func callPlugins(method: String, parameters: [Any] = []) {
            for plugin in plugins.values {
                plugin.callMethod(method, parameters: parameters)
            }
        }
        
        /// 设置主题
        /// - Parameter theme: 主题
        func setTheme(_ theme: HCollViewTheme) {
            currentTheme = theme
        }
        
        /// 获取当前主题
        /// - Returns: 当前主题
        func getCurrentTheme() -> HCollViewTheme {
            return currentTheme
        }
        
        /// 设置语言
        /// - Parameter language: 语言代码
        func setLanguage(_ language: String) {
            currentLanguage = language
        }
        
        /// 获取当前语言
        /// - Returns: 当前语言代码
        func getCurrentLanguage() -> String {
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
        func clearPlugins() {
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
    func registerPlugin(_ plugin: HCollViewPlugin, forKey key: String) {
        extensibilityManager.registerPlugin(plugin, forKey: key)
    }
    
    /// 移除插件
    /// - Parameter key: 插件键
    func removePlugin(forKey key: String) {
        extensibilityManager.removePlugin(forKey: key)
    }
    
    /// 获取插件
    /// - Parameter key: 插件键
    /// - Returns: 插件
    func getPlugin(forKey key: String) -> HCollViewPlugin? {
        return extensibilityManager.getPlugin(forKey: key)
    }
    
    /// 调用所有插件的方法
    /// - Parameters:
    ///   - method: 方法名
    ///   - parameters: 参数
    func callPlugins(method: String, parameters: [Any] = []) {
        extensibilityManager.callPlugins(method: method, parameters: parameters)
    }
    
    /// 设置主题
    /// - Parameter theme: 主题
    func setTheme(_ theme: HCollViewTheme) {
        extensibilityManager.setTheme(theme)
        applyTheme()
    }
    
    /// 获取当前主题
    /// - Returns: 当前主题
    func getCurrentTheme() -> HCollViewTheme {
        return extensibilityManager.getCurrentTheme()
    }
    
    /// 设置语言
    /// - Parameter language: 语言代码
    func setLanguage(_ language: String) {
        extensibilityManager.setLanguage(language)
    }
    
    /// 获取当前语言
    /// - Returns: 当前语言代码
    func getCurrentLanguage() -> String {
        return extensibilityManager.getCurrentLanguage()
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
    
    /// 应用主题
    private func applyTheme() {
        let theme = getCurrentTheme()
        
        // 应用主题到集合视图
        backgroundColor = theme.backgroundColor
        tintColor = theme.tintColor
        
        // 应用主题到单元格
        // 这里需要根据实际情况实现
    }
    
    /// 清理插件
    func clearPlugins() {
        extensibilityManager.clearPlugins()
    }
}

/// HCollView 插件协议
protocol HCollViewPlugin {
    
    /// 初始化
    init()
    
    /// 设置
    /// - Parameter manager: 扩展性管理器
    func setup(_ manager: ExtensibilityManager)
    
    /// 拆卸
    func teardown()
    
    /// 调用方法
    /// - Parameters:
    ///   - method: 方法名
    ///   - parameters: 参数
    func callMethod(_ method: String, parameters: [Any])
}

/// HCollView 主题协议
protocol HCollViewTheme {
    
    /// 背景颜色
    var backgroundColor: UIColor { get }
    
    /// 主题色
    var tintColor: UIColor { get }
    
    /// 文本颜色
    var textColor: UIColor { get }
    
    /// 副标题颜色
    var secondaryTextColor: UIColor { get }
    
    /// 边框颜色
    var borderColor: UIColor { get }
    
    /// 边框宽度
    var borderWidth: CGFloat { get }
    
    /// 圆角半径
    var cornerRadius: CGFloat { get }
    
    /// 阴影颜色
    var shadowColor: UIColor { get }
    
    /// 阴影偏移
    var shadowOffset: CGSize { get }
    
    /// 阴影半径
    var shadowRadius: CGFloat { get }
    
    /// 阴影不透明度
    var shadowOpacity: Float { get }
}

/// 默认主题
class DefaultTheme: HCollViewTheme {
    
    var backgroundColor: UIColor { return .white }
    var tintColor: UIColor { return .blue }
    var textColor: UIColor { return .black }
    var secondaryTextColor: UIColor { return .gray }
    var borderColor: UIColor { return .lightGray }
    var borderWidth: CGFloat { return 1.0 }
    var cornerRadius: CGFloat { return 8.0 }
    var shadowColor: UIColor { return .black }
    var shadowOffset: CGSize { return CGSize(width: 0, height: 2) }
    var shadowRadius: CGFloat { return 4.0 }
    var shadowOpacity: Float { return 0.2 }
}

/// 暗黑主题
class DarkTheme: HCollViewTheme {
    
    var backgroundColor: UIColor { return .black }
    var tintColor: UIColor { return .blue }
    var textColor: UIColor { return .white }
    var secondaryTextColor: UIColor { return .lightGray }
    var borderColor: UIColor { return .darkGray }
    var borderWidth: CGFloat { return 1.0 }
    var cornerRadius: CGFloat { return 8.0 }
    var shadowColor: UIColor { return .white }
    var shadowOffset: CGSize { return CGSize(width: 0, height: 2) }
    var shadowRadius: CGFloat { return 4.0 }
    var shadowOpacity: Float { return 0.1 }
}

/// 示例插件
class ExamplePlugin: HCollViewPlugin {
    
    required init() {}
    
    func setup(_ manager: ExtensibilityManager) {
        print("ExamplePlugin setup")
    }
    
    func teardown() {
        print("ExamplePlugin teardown")
    }
    
    func callMethod(_ method: String, parameters: [Any]) {
        print("ExamplePlugin callMethod: \(method), parameters: \(parameters)")
    }
}
