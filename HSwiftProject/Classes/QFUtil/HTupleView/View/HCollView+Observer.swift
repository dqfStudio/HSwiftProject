//
//  HCollView+Observer.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/6.
//  Copyright © 2025 wind. All rights reserved.
//

import Foundation

// MARK: - 类型安全的观察者模式

/// 观察者回调类型定义
enum HCollObserverAction {
    /// 重新加载数据
    case reloadData
    
    /// 自定义操作
    case custom(action: (HCollView) -> Void)
}

/// 类型安全的观察者类，用于管理 HCollView 实例并执行指定操作
///
/// 提供以下功能：
/// - 批量刷新和释放 HCollView 实例
/// - 按 key 过滤特定实例
/// - 类型安全的操作执行（替代 NSSelectorFromString + perform）
///
/// 使用示例：
/// ```swift
/// // 添加观察者
/// HCollObserver.addObserver(collView)
///
/// // 批量刷新
/// HCollObserver.perform(action: .reloadData)
///
/// // 按条件刷新
/// HCollObserver.perform(where: { $0.reloadCollKey == "home" }) { action in
///     case .reloadData:
///         // 执行刷新
/// }
/// ```
@MainActor
class HCollObserver {
    // MARK: - Properties
    
    /// 使用 NSHashTable 存储弱引用的 HCollView 实例，避免循环引用
    private static let hashColls = NSHashTable<HCollView>.weakObjects()
    
    // MARK: - Public Methods
    
    /// 添加观察者
    /// - Parameter observer: 要添加的观察者
    static func addObserver(_ observer: HCollView?) {
        guard let observer = observer, !hashColls.contains(observer) else { return }
        hashColls.add(observer)
    }
    
    /// 移除观察者
    /// - Parameter observer: 要移除的观察者
    static func removeObserver(_ observer: HCollView?) {
        guard let observer = observer else { return }
        hashColls.remove(observer)
    }
    
    /// 对所有观察者执行指定操作
    /// - Parameter action: 要执行的操作
    static func perform(action: HCollObserverAction) {
        let objects = hashColls.allObjects.reversed()
        objects.forEach { coll in
            executeAction(action, on: coll)
        }
    }
    
    /// 对符合特定条件的观察者执行指定操作
    /// - Parameters:
    ///   - predicate: 过滤条件
    ///   - action: 要执行的操作
    static func perform(where predicate: @escaping (HCollView) -> Bool, action: HCollObserverAction) {
        let objects = hashColls.allObjects.filter(predicate).reversed()
        objects.forEach { coll in
            executeAction(action, on: coll)
        }
    }
    
    /// 刷新所有 HCollView 实例
    /// - Parameter completion: 刷新完成后的回调（在主线程执行）
    static func refreshAll(completion: @escaping () -> Void) {
        // 反向执行，确保后添加的先刷新
        let colls = hashColls.allObjects.reversed()
        colls.forEach { $0.reloadCollData() }
        completion()
    }
    
    /// 根据 reloadCollKey 刷新指定的 HCollView 实例
    /// - Parameters:
    ///   - key: 刷新的 key
    ///   - completion: 刷新完成后的回调（在主线程执行）
    static func refreshByKey(key: String, completion: @escaping () -> Void) {
        perform(where: { $0.reloadCollKey == key }, action: .reloadData)
        completion()
    }
    
    /// 根据 releaseCollKey 释放指定的 HCollView 实例
    /// - Parameters:
    ///   - key: 释放的 key
    ///   - completion: 释放完成后的回调（在主线程执行）
    static func releaseByKey(key: String, completion: @escaping () -> Void) {
        // 反向执行，确保后添加的先释放
        let colls = hashColls.allObjects.filter { $0.releaseCollKey == key }.reversed()
        colls.forEach { $0.releaseCollBlock() }
        completion()
    }
    
    // MARK: - Private Methods
    
    /// 在指定实例上执行操作
    /// - Parameters:
    ///   - action: 要执行的操作
    ///   - coll: 目标实例
    private static func executeAction(_ action: HCollObserverAction, on coll: HCollView) {
        switch action {
        case .reloadData:
            coll.reloadCollData()
        case .custom(let customAction):
            customAction(coll)
        }
    }
}