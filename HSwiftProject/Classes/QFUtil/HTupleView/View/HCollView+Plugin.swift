//
//  HCollView+Plugin.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 插件协议
protocol HCollViewPlugin {
    /// 插件名称
    var name: String { get }
    
    /// 插件版本
    var version: String { get }
    
    /// 初始化插件
    /// - Parameter collView: HCollView 实例
    func initialize(_ collView: HCollView)
    
    /// 销毁插件
    func destroy()
    
    /// 处理事件
    /// - Parameters:
    ///   - event: 事件名称
    ///   - data: 事件数据
    func handleEvent(_ event: String, data: Any?)
}

/// HCollView 插件管理器
class HCollViewPluginManager {
    
    // MARK: - 单例
    static let shared = HCollViewPluginManager()
    private init() {}
    
    // MARK: - 属性
    
    /// 已注册的插件
    private var plugins: [HCollViewPlugin] = []
    
    /// 插件映射
    private var pluginMap: [String: HCollViewPlugin] = [:]
    
    // MARK: - 方法
    
    /// 注册插件
    /// - Parameter plugin: 插件实例
    func registerPlugin(_ plugin: HCollViewPlugin) {
        if !plugins.contains(where: { $0.name == plugin.name }) {
            plugins.append(plugin)
            pluginMap[plugin.name] = plugin
        }
    }
    
    /// 移除插件
    /// - Parameter pluginName: 插件名称
    func removePlugin(_ pluginName: String) {
        if let index = plugins.firstIndex(where: { $0.name == pluginName }) {
            let plugin = plugins[index]
            plugin.destroy()
            plugins.remove(at: index)
            pluginMap.removeValue(forKey: pluginName)
        }
    }
    
    /// 获取插件
    /// - Parameter pluginName: 插件名称
    /// - Returns: 插件实例
    func getPlugin(_ pluginName: String) -> HCollViewPlugin? {
        return pluginMap[pluginName]
    }
    
    /// 获取所有插件
    /// - Returns: 插件数组
    func getAllPlugins() -> [HCollViewPlugin] {
        return plugins
    }
    
    /// 初始化所有插件
    /// - Parameter collView: HCollView 实例
    func initializeAllPlugins(_ collView: HCollView) {
        for plugin in plugins {
            plugin.initialize(collView)
        }
    }
    
    /// 销毁所有插件
    func destroyAllPlugins() {
        for plugin in plugins {
            plugin.destroy()
        }
        plugins.removeAll()
        pluginMap.removeAll()
    }
    
    /// 分发事件
    /// - Parameters:
    ///   - event: 事件名称
    ///   - data: 事件数据
    func dispatchEvent(_ event: String, data: Any?) {
        for plugin in plugins {
            plugin.handleEvent(event, data: data)
        }
    }
}

/// HCollView 插件扩展
///
/// 提供插件系统支持
extension HCollView {
    
    /// 插件管理器
    var pluginManager: HCollViewPluginManager {
        return HCollViewPluginManager.shared
    }
    
    /// 注册插件
    /// - Parameter plugin: 插件实例
    func registerPlugin(_ plugin: HCollViewPlugin) {
        pluginManager.registerPlugin(plugin)
        plugin.initialize(self)
    }
    
    /// 移除插件
    /// - Parameter pluginName: 插件名称
    func removePlugin(_ pluginName: String) {
        pluginManager.removePlugin(pluginName)
    }
    
    /// 获取插件
    /// - Parameter pluginName: 插件名称
    /// - Returns: 插件实例
    func getPlugin(_ pluginName: String) -> HCollViewPlugin? {
        return pluginManager.getPlugin(pluginName)
    }
    
    /// 获取所有插件
    /// - Returns: 插件数组
    func getAllPlugins() -> [HCollViewPlugin] {
        return pluginManager.getAllPlugins()
    }
    
    /// 分发事件
    /// - Parameters:
    ///   - event: 事件名称
    ///   - data: 事件数据
    func dispatchEvent(_ event: String, data: Any?) {
        pluginManager.dispatchEvent(event, data: data)
    }
    
    /// 内置插件
    enum BuiltInPlugin {
        case log
        case analytics
        case performance
        case crash
    }
    
    /// 注册内置插件
    /// - Parameter plugin: 内置插件类型
    func registerBuiltInPlugin(_ plugin: BuiltInPlugin) {
        switch plugin {
        case .log:
            registerPlugin(HCollViewLogPlugin())
        case .analytics:
            registerPlugin(HCollViewAnalyticsPlugin())
        case .performance:
            registerPlugin(HCollViewPerformancePlugin())
        case .crash:
            registerPlugin(HCollViewCrashPlugin())
        }
    }
}

// MARK: - 内置插件

/// 日志插件
class HCollViewLogPlugin: HCollViewPlugin {
    var name: String = "LogPlugin"
    var version: String = "1.0.0"
    
    func initialize(_ collView: HCollView) {
        print("HCollViewLogPlugin initialized")
    }
    
    func destroy() {
        print("HCollViewLogPlugin destroyed")
    }
    
    func handleEvent(_ event: String, data: Any?) {
        print("HCollViewLogPlugin received event: \(event), data: \(String(describing: data))")
    }
}

/// 分析插件
class HCollViewAnalyticsPlugin: HCollViewPlugin {
    var name: String = "AnalyticsPlugin"
    var version: String = "1.0.0"
    
    func initialize(_ collView: HCollView) {
        print("HCollViewAnalyticsPlugin initialized")
    }
    
    func destroy() {
        print("HCollViewAnalyticsPlugin destroyed")
    }
    
    func handleEvent(_ event: String, data: Any?) {
        // 这里可以实现分析逻辑
        print("HCollViewAnalyticsPlugin received event: \(event)")
    }
}

/// 性能监控插件
class HCollViewPerformancePlugin: HCollViewPlugin {
    var name: String = "PerformancePlugin"
    var version: String = "1.0.0"
    
    private var startTime: Date?
    private var performanceData: [String: TimeInterval] = [:]
    
    func initialize(_ collView: HCollView) {
        print("HCollViewPerformancePlugin initialized")
    }
    
    func destroy() {
        print("HCollViewPerformancePlugin destroyed")
    }
    
    func handleEvent(_ event: String, data: Any?) {
        switch event {
        case "reloadDataStart":
            startTime = Date()
        case "reloadDataEnd":
            if let startTime = startTime {
                let duration = Date().timeIntervalSince(startTime)
                performanceData["reloadData"] = duration
                print("HCollViewPerformancePlugin: reloadData took \(duration) seconds")
            }
        default:
            break
        }
    }
}

/// 崩溃防护插件
class HCollViewCrashPlugin: HCollViewPlugin {
    var name: String = "CrashPlugin"
    var version: String = "1.0.0"
    
    func initialize(_ collView: HCollView) {
        print("HCollViewCrashPlugin initialized")
        // 这里可以设置崩溃防护
    }
    
    func destroy() {
        print("HCollViewCrashPlugin destroyed")
    }
    
    func handleEvent(_ event: String, data: Any?) {
        // 这里可以实现崩溃监控逻辑
        print("HCollViewCrashPlugin received event: \(event)")
    }
}
